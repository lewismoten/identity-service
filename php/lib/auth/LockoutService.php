<?php
declare(strict_types=1);

namespace Auth;

final class LockoutService
{
    public function logFailedAttempt(?int $userId, string $identifier, ?string $ip): void
    {
        $ip = $ip ?: null;

        db()->prepare("
            INSERT INTO failed_login_attempts (user_id, username, ip_address, attempted_at)
            VALUES (:uid, :u, :ip, NOW())
        ")->execute([
            'uid' => $userId,
            'u'   => $identifier,
            'ip'  => $ip ?? '',
        ]);
    }

    /**
     * True if there is an active lockout for the user or (optionally) the IP.
     */
    public function isLocked(int $userId, ?string $ip): bool
    {
        // User lockout
        if ($this->hasActiveLockoutForUser($userId)) {
            return true;
        }

        // Optional IP-based lockout
        if ($ip && \Settings::bool(\SettingKeys::SECURITY_LOCKOUT_BY_IP, true)) {
            if ($this->hasActiveLockoutForIp($ip)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Called after a failed password check. 
     * Creates/extends lockout when thresholds are reached.
     */
    public function handleEscalation(int $userId, ?string $ip): void
    {
        $maxFailed  = \Settings::int(\SettingKeys::SECURITY_MAX_FAILED_LOGINS, 5);
        $windowMin  = \Settings::int(\SettingKeys::SECURITY_FAILED_WINDOW_MINUTES, 15);

        $failCountUser = $this->countRecentFailuresForUser($userId, $windowMin);

        if ($failCountUser >= $maxFailed) {
            $duration = $this->computeLockoutDurationMinutes($userId);
            $this->lockUser($userId, $duration, 'too_many_failed_logins', [
                'window_minutes' => $windowMin,
                'failures'       => $failCountUser,
            ]);
        }

        if ($ip && \Settings::bool(\SettingKey::SECURITY_LOCKOUT_BY_IP, true)) {
            $failCountIp = $this->countRecentFailuresForIp($ip, $windowMin);
            if ($failCountIp >= $maxFailed) {
                $duration = $this->computeLockoutDurationMinutesForIp($ip);
                $this->lockIp($ip, $duration, 'too_many_failed_logins_ip', [
                    'window_minutes' => $windowMin,
                    'failures'       => $failCountIp,
                ]);
            }
        }
    }

    public function lockUser(int $userId, int $durationMinutes, string $reason, array $meta = []): void
    {
        $until = DbDate::inMinutes($durationMinutes);

        db()->prepare("
            INSERT INTO account_lockouts
              (user_id, ip_address, lock_reason, locked_at, locked_until, meta)
            VALUES
              (:uid, NULL, :r, NOW(), :until, :meta)
        ")->execute([
            'uid'   => $userId,
            'r'     => $reason,
            'until' => $until,
            'meta'  => $meta ? json_encode($meta, JSON_UNESCAPED_SLASHES) : null,
        ]);
    }

    public function lockIp(string $ip, int $durationMinutes, string $reason, array $meta = []): void
    {
        $until = DbDate::inMinutes($durationMinutes);

        db()->prepare("
            INSERT INTO account_lockouts
              (user_id, ip_address, lock_reason, locked_at, locked_until, meta)
            VALUES
              (NULL, :ip, :r, NOW(), :until, :meta)
        ")->execute([
            'ip'    => $ip,
            'r'     => $reason,
            'until' => $until,
            'meta'  => $meta ? json_encode($meta, JSON_UNESCAPED_SLASHES) : null,
        ]);
    }

    private function hasActiveLockoutForUser(int $userId): bool
    {
        $stmt = db()->prepare("
            SELECT 1
              FROM account_lockouts
             WHERE user_id = ?
               AND cleared_at IS NULL
               AND (locked_until IS NULL OR locked_until > NOW())
             LIMIT 1
        ");
        $stmt->execute([$userId]);
        return (bool)$stmt->fetchColumn();
    }

    private function hasActiveLockoutForIp(string $ip): bool
    {
        $stmt = db()->prepare("
            SELECT 1
              FROM account_lockouts
             WHERE ip_address = ?
               AND cleared_at IS NULL
               AND (locked_until IS NULL OR locked_until > NOW())
             LIMIT 1
        ");
        $stmt->execute([$ip]);
        return (bool)$stmt->fetchColumn();
    }

    /* -----------------------------
       Failure counting
       ----------------------------- */

    private function countRecentFailuresForUser(int $userId, int $windowMinutes): int
    {
        $stmt = db()->prepare("
            SELECT COUNT(*)
              FROM failed_login_attempts
             WHERE user_id = ?
               AND attempted_at >= (NOW() - INTERVAL ? MINUTE)
        ");
        $stmt->execute([$userId, $windowMinutes]);
        return (int)$stmt->fetchColumn();
    }

    private function countRecentFailuresForIp(string $ip, int $windowMinutes): int
    {
        $stmt = db()->prepare("
            SELECT COUNT(*)
              FROM failed_login_attempts
             WHERE ip_address = ?
               AND attempted_at >= (NOW() - INTERVAL ? MINUTE)
        ");
        $stmt->execute([$ip, $windowMinutes]);
        return (int)$stmt->fetchColumn();
    }

    private function computeLockoutDurationMinutes(int $userId): int
    {
        $escalate = \Settings::bool(\SettingKeys::SECURITY_LOCKOUT_ESCALATION, true);

        if (!$escalate) {
          return \Settings::int(\SettingKeys::SECURITY_LOCKOUT_DURATION_MINUTES, 30);
        }

        $recent = \Settings::int(\SettingKeys::SECURITY_LOCKOUT_RECENT_HOURS, 24);
        $count = $this->countRecentLockoutsForUser($userId, $recent);
        return $this->computeEscalatedDuration($count);
    }
    private function computeLockoutDurationMinutesForIp(string $ip): int
    {
        $escalate = \Settings::bool(\SettingKeys::SECURITY_LOCKOUT_ESCALATION, true);

        if (!$escalate) {
          return \Settings::int(\SettingKeys::SECURITY_LOCKOUT_DURATION_MINUTES, 30);
        }

        $recent = \Settings::int(\SettingKeys::SECURITY_LOCKOUT_RECENT_HOURS, 24);
        $count = $this->countRecentLockoutsForIp($ip, $recent);
        return $this->computeEscalatedDuration($count);
    }
    private function computeEscalatedDuration($baseMinutes, $count) {
        $cap  = \Settings::int(\SettingKeys::SECURITY_LOCKOUT_ESCALATION_MAX, 5);
        $max  = \Settings::int(\SettingKeys::SECURITY_MAX_LOCKOUT_MINUTES, 1440);
        $base = \Settings::int(\SettingKeys::SECURITY_LOCKOUT_DURATION_MINUTES, 30);
        $duration = $base * (2 ** min($count, $cap));
        return min($duration, $max);
    }
    private function countRecentLockoutsForUser(int $userId, int $hours): int
    {
        $stmt = db()->prepare("
            SELECT COUNT(*)
              FROM account_lockouts
             WHERE user_id = ?
               AND locked_at >= (NOW() - INTERVAL ? HOUR)
        ");
        $stmt->execute([$userId, $hours]);
        return (int)$stmt->fetchColumn();
    }

    private function countRecentLockoutsForIp(string $ip, int $hours): int
    {
        $stmt = db()->prepare("
            SELECT COUNT(*)
              FROM account_lockouts
             WHERE ip_address = ?
               AND locked_at >= (NOW() - INTERVAL ? HOUR)
        ");
        $stmt->execute([$ip, $hours]);
        return (int)$stmt->fetchColumn();
    }
}

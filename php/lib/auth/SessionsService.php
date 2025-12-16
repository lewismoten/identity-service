<?php
declare(strict_types=1);

namespace Auth;

final class SessionService
{
    /**
     * Create a new session + refresh token.
     *
     * Returns token_id (public) + refresh_token (secret) + expires_at + session_id.
     * Store refresh_token as HttpOnly cookie (recommended).
     *
     * @return array{session_id:int, token_id:string, refresh_token:string, expires_at:string}
     */
    public function create(int $userId, ?string $ip, ?string $ua): array
    {
        $tokenId = crypto()->new_id();          // public identifier (UUID)
        $refresh = crypto()->random_token(32);  // secret bearer token (base64url)

        $refreshHash = crypto()->hash_bin($refresh);

        $ttlDays  = \Settings::int(\SettingKeys::SESSIONS_REFRESH_TTL_DAYS, 30);
        $expires  = \DbDate::inDays($ttlDays);

        // Enforce max sessions per user (best-effort)
        $max = \Settings::int(\SettingKeys::SESSIONS_MAX_PER_USER, 10);
        $this->revokeOldestIfOverLimit($userId, $max);

        db()->prepare("
            INSERT INTO auth_sessions
              (user_id, token_id, refresh_token_hash, issued_at, expires_at, ip_address, user_agent)
            VALUES
              (?, ?, ?, NOW(), ?, ?, ?)
        ")->execute([$userId, $tokenId, $refreshHash, $expires, $ip, $ua]);

        $sessionId = (int)db()->lastInsertId();

        return [
            'session_id'    => $sessionId,
            'token_id'      => $tokenId,
            'refresh_token' => $refresh,
            'expires_at'    => $expires,
        ];
    }

    /**
     * Verify a refresh token for a token_id; optionally rotate refresh token.
     *
     * @return array{session_id:int, token_id:string, refresh_token:string, expires_at:string, user_id:int}
     */
    public function refresh(string $tokenId, string $refreshToken, ?string $ip, ?string $ua): array
    {
        $row = $this->getActiveByTokenId($tokenId);
        if (!$row) {
            throw new \RuntimeException('invalid_session');
        }

        $sessionId  = (int)$row['id'];
        $userId     = (int)$row['user_id'];
        $expiresAt  = (string)$row['expires_at'];

        $presentedHash = crypto()->hash_bin($refreshToken);
        if (!hash_equals($row['refresh_token_hash'], $presentedHash)) {
            $this->revoke($sessionId, 'refresh_token_mismatch');
            throw new \RuntimeException('invalid_refresh_token');
        }

        $rotate = \Settings::bool(\SettingKeys::SESSIONS_ROTATE_REFRESH_TOKENS, true);

        if ($rotate) {
            $newTokenId = crypto()->new_id();
            $newRefresh = crypto()->random_token(32);
            $newHash    = crypto()->hash_bin($newRefresh);

            $ttlDays = \Settings::int(\SettingKeys::SESSIONS_REFRESH_TTL_DAYS, 30);
            $newExpires = \DbDate::inDays($ttlDays);

            db()->prepare("
                UPDATE auth_sessions
                   SET revoked_at = NOW(),
                       replaced_by_token_id = ?,
                       last_used_at = NOW()
                 WHERE id = ?
                 LIMIT 1
            ")->execute([$newTokenId, $sessionId]);

            db()->prepare("
                INSERT INTO auth_sessions (
                  user_id, 
                  token_id, 
                  refresh_token_hash, 
                  issued_at, 
                  expires_at, 
                  last_used_at, 
                  ip_address, 
                  user_agent
                ) VALUES (?, ?, ?, NOW(), ?, NOW(), ?, ?)
            ")->execute([$userId, $newTokenId, $newHash, $newExpires, $ip, $ua]);

            $newSessionId = (int)db()->lastInsertId();

            return [
                'session_id'    => $newSessionId,
                'user_id'       => $userId,
                'token_id'      => $newTokenId,
                'refresh_token' => $newRefresh,
                'expires_at'    => $newExpires,
            ];
        }

        db()->prepare("
            UPDATE auth_sessions
               SET last_used_at = NOW(),
                   ip_address = COALESCE(?, ip_address),
                   user_agent = COALESCE(?, user_agent)
             WHERE id = ?
             LIMIT 1
        ")->execute([$ip, $ua, $sessionId]);

        return [
            'session_id'    => $sessionId,
            'user_id'       => $userId,
            'token_id'      => $tokenId,
            'refresh_token' => $refreshToken,
            'expires_at'    => $expiresAt,
        ];
    }

    public function revoke(int $sessionId, string $reason = 'revoked'): void
    {
        db()->prepare("
            UPDATE auth_sessions
               SET revoked_at = NOW()
             WHERE id = ?
               AND revoked_at IS NULL
             LIMIT 1
        ")->execute([$sessionId]);
    }

    public function revokeByTokenId(string $tokenId): bool
    {
        $stmt = db()->prepare("
            UPDATE auth_sessions
               SET revoked_at = NOW()
             WHERE token_id = ?
               AND revoked_at IS NULL
             LIMIT 1
        ");
        $stmt->execute([$tokenId]);
        return $stmt->rowCount() > 0;
    }
    public function revokeByRefreshToken(string $refreshToken): bool
    {
      $hash = crypto()->hash_bin($refreshToken);
      $stmt = db()->prepare("
        UPDATE auth_sessions
          SET revoked_at = NOW()
        WHERE refresh_token_hash = ?
          AND revoked_at IS NULL
        LIMIT 1
      ");
      $stmt->execute([$hash]);
      return $stmt->rowCount() > 0;
    }
    public function getActiveByTokenId(string $tokenId): ?array
    {
        $stmt = db()->prepare("
            SELECT id, user_id, token_id, refresh_token_hash, expires_at
              FROM auth_sessions
             WHERE token_id = ?
             AND revoked_at IS NULL
             AND expires_at > NOW()
             LIMIT 1
        ");
        $stmt->execute([$tokenId]);
        $row = $stmt->fetch();

        return $row !== false ? $row : null;
    }

    /**
     * Maintenance: revoke expired sessions
     */
    public function pruneExpired(): int
    {
        $stmt = db()->prepare("
            UPDATE auth_sessions
               SET revoked_at = NOW()
             WHERE revoked_at IS NULL
               AND expires_at <= NOW()
        ");
        $stmt->execute();
        return $stmt->rowCount();
    }

    private function revokeOldestIfOverLimit(int $userId, int $maxSessions): void
    {
        if ($maxSessions <= 0) return;

        $stmt = db()->prepare("
            SELECT COUNT(*)
              FROM auth_sessions
             WHERE user_id = ?
               AND revoked_at IS NULL
               AND expires_at > NOW()
        ");
        $stmt->execute([$userId]);
        $count = (int)$stmt->fetchColumn();

        if ($count < $maxSessions) return;

        $toRevoke = ($count - $maxSessions) + 1;

        db()->prepare("
            UPDATE auth_sessions
               SET revoked_at = NOW()
             WHERE user_id = ?
               AND revoked_at IS NULL
               AND expires_at > NOW()
             ORDER BY issued_at ASC
             LIMIT {$toRevoke}
        ")->execute([$userId]);
    }
}

<?php
declare(strict_types=1);

namespace Auth;

final class AuditService
{
    /**
     * Log an audit event.
     *
     * @param int|null    $actorUserId   The authenticated user performing the action (nullable for anonymous/system events)
     * @param string      $eventType     e.g. "login.success", "mfa.enabled", "api_key.created"
     * @param string|null $ip            Remote IP address (nullable)
     * @param string|null $userAgent     User agent (nullable)
     * @param int|null    $sessionId     auth_sessions.id (nullable)
     * @param int|null    $targetUserId  Affected user (nullable) e.g. admin changes another user
     * @param array|null  $meta          Extra data (will be JSON-encoded)
     */
    public function log(
        ?int $actorUserId,
        string $eventType,
        ?string $ip = null,
        ?string $userAgent = null,
        ?int $sessionId = null,
        ?int $targetUserId = null,
        ?array $meta = null
    ): void {
        $meta = $meta ?? [];
        $meta['request_id'] = \RequestContext::id();
        $metaJson = json_encode($meta, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        
        db()->prepare("
            INSERT INTO user_audit_log
                (user_id, event_type, event_at, ip_address, user_agent, session_id, target_user_id, meta)
            VALUES
                (:uid, :type, NOW(), :ip, :ua, :sid, :tuid, :meta)
        ")->execute([
            'uid'  => $actorUserId,
            'type' => $eventType,
            'ip'   => $ip,
            'ua'   => $userAgent,
            'sid'  => $sessionId,
            'tuid' => $targetUserId,
            'meta' => $metaJson,
        ]);
    }

    /**
     * Convenience for logging auth events with consistent meta.
     */
    public function authEvent(
        ?int $userId,
        string $eventType,
        ?string $ip,
        ?string $userAgent,
        array $meta = []
    ): void {
        $this->log($userId, $eventType, $ip, $userAgent, null, null, $meta ?: null);
    }

    /**
     * Optional maintenance: prune old audit logs.
     * (Call from a cron endpoint or CLI script.)
     */
    public function prune(): int
    {
        $retentionDays = \Settings::int(\SettingKeys::AUDIT_RETENTION_DAYS, 365);

        $stmt = db()->prepare("
          DELETE FROM user_audit_log
          WHERE event_at < (NOW() - INTERVAL ? DAY)
        ");
        $stmt->execute([$retentionDays]);

        return $stmt->rowCount();
    }

    /**
     * privacy maintenance: anonymize IPs after N days.
     */
    public function anonymizeIps(): int
    {
      $days = \Settings::int(\SettingKeys::AUDIT_ANONYMIZE_IP_AFTER_DAYS, 90);

      $stmt = db()->prepare("
      SELECT id, ip_address
        FROM user_audit_log
        WHERE ip_address IS NOT NULL
          AND ip_anonymized_at IS NULL
          AND event_at < (NOW() - INTERVAL ? DAY)
        LIMIT 5000
      ");
      $stmt->execute([$days]);
      $rows = $stmt->fetchAll();
      if (!$rows) return 0;
      $upd = db()->prepare("
        UPDATE user_audit_log
        SET 
          ip_address = ?, 
          ip_anonymized_at = NOW()
        WHERE id = ?
      ");
      $count = 0;
      foreach ($rows as $r) {
        $upd->execute([
          $this->anonymizeIp((string)$r['ip_address']), 
          (int)$r['id']
        ]);
        $count++;
      }
      return $count;
    }
  /**
   * Returns anonymized IP string, or null if invalid.
   */
  private function anonymizeIp(string $ip): ?string
  {
    $ip = trim($ip);
    if ($ip === '') return null;

    // IPv4
    if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
      $parts = explode('.', $ip);
      $parts[3] = '0';
      return implode('.', $parts);
    }

    // IPv6
    if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
      $bin = @inet_pton($ip);
      if ($bin === false || strlen($bin) !== 16) return null;
      // zero the last 8 bytes (keep /64)
      $bin = substr($bin, 0, 8) . str_repeat("\0", 8);
      $out = inet_ntop($bin);
      return $out !== false ? $out : null;
    }
    return null;
}
}

<?php
function isAccountLocked(int $userId, ?string $ip): bool {
  return (bool)(
    db()
    ->prepare("
      SELECT 1
      FROM account_lockouts
      WHERE (user_id = :uid OR (:ip IS NOT NULL AND ip_address = :ip))
        AND cleared_at IS NULL
        AND (locked_until IS NULL OR locked_until > NOW())
      LIMIT 1
    ")
    ->execute([':uid'=>$userId, ':ip'=>$ip])
    ->fetchColumn()
  );
}
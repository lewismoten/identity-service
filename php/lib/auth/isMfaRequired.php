<?php
function isMfaRequired(int $userId): bool {
  return (bool)(
    db()
    ->prepare("
        SELECT 1
        FROM mfa_methods
        WHERE user_id = ?
          AND is_enabled = 1
        LIMIT 1
    ")
    ->execute([$userId])
    ->fetchColumn()
  );
}
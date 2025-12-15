<?php
function isMfaBackupCodeEnabledByUser($userId) {
  $is_enabled = db()->prepare("
      SELECT COUNT(*)
      FROM user_backup_codes
      WHERE user_id = ?
        AND used_at IS NULL
    ")->execute([$userId])
    ->fetchColumn() ?: 0;
  return (int)$is_enabled === 1;
}
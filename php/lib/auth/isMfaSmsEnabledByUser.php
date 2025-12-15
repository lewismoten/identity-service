<?php
function isMfaSmsEnabledByUser($userId) {
  $is_enabled = db()->prepare("
        SELECT COUNT(*)
        FROM user_phones
        WHERE user_id = ?
          AND revoked_at IS NULL
          AND is_verified = 1
    ")->execute([$userId])
    ->fetchColumn() ?: 0;
  return (int)$is_enabled === 1;
}
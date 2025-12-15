<?php
function isMfaTotpEnabledByUser($userId) {
  $is_enabled = db()->prepare("
        SELECT is_enabled
        FROM user_totp
        WHERE user_id = ?
        LIMIT 1
    ")->execute([$userId])
    ->fetchColumn() ?: 0;
    
  return (int)$is_enabled === 1;
}
<?php
function isMfaPasskeyEnabledByUser($userId) {
  $is_enabled = db()->prepare("
        SELECT COUNT(*)
        FROM webauthn_credentials
        WHERE user_id = ?
          AND revoked_at IS NULL
    ")->execute([$userId])
    ->fetchColumn() ?: 0;
  return (int)$is_enabled === 1;
}
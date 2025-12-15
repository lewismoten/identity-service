<?php
require_once __DIR__ .'/../settings/getSettingAsInt.php';

function getFailedLoginAttemptsByUser($userId) {
  $windowMin = getSettingAsInt('security', 'failed_login_window_minutes', 15);
  return (int)(
    db()
    ->prepare("
      SELECT COUNT(*)
      FROM failed_login_attempts
      WHERE user_id = ?
        AND attempted_at >= (NOW() - INTERVAL ? MINUTE)
    ")
    ->execute([$userId, $windowMin])
    ->fetchColumn()
  );
}

<?php
require_once __DIR__ .'/../settings/getSettingAsInt.php';

function lockAccount($userId, $ip, $reason, $userFails, $ipFails) {
  $durationMin = getSettingAsInt('security', 'lockout_duration_minutes', 30);
  $windowMin = getSettingAsInt('security', 'failed_login_window_minutes', 15);
  
  $lockedUntil = DbDate::inMinutes($durationMin);
  db()->prepare("
      INSERT INTO account_lockouts (user_id, ip_address, lock_reason, locked_until, meta)
      VALUES (?, ?, ?, ?, JSON_OBJECT('userFails', ?, 'ipFails', ?, 'windowMinutes', ?))
  ")->execute([$userId, $ip, $reason, $lockedUntil, $userFails, $ipFails, $windowMin]);
}
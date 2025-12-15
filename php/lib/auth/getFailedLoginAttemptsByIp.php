<?php
require_once __DIR__ .'/../settings/getSettingAsInt.php';
require_once __DIR__ .'/../settings/getSettingAsBool.php';

function getFailedLoginAttemptsByIp($ip) {
  if(!$ip) return 0;
  $lockoutByIp = getSettingAsBool('security', 'lockout_by_ip_enabled', true);
  if(!$lockoutByIp) return 0;
  $windowMin = getSettingAsInt('security', 'failed_login_window_minutes', 15);
  return (int)(
    db()
    ->prepare("
      SELECT COUNT(*)
      FROM failed_login_attempts
      WHERE ip_address = ?
        AND attempted_at >= (NOW() - INTERVAL ? MINUTE)
    ")
    ->execute([$ip, $windowMin])
    ->fetchColumn()
  );
}

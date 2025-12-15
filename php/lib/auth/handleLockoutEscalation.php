<?php
require_once __DIR__ .'/../settings/getSettingAsInt.php';
require_once __DIR__ .'/../settings/getSettingAsBool.php';
require_once __DIR__ .'/getFailedLoginAttemptsByUser.php';
require_once __DIR__ .'/getFailedLoginAttemptsByIp.php';
require_once __DIR__ .'/isAccountLocked.php';
/**
 * If too many failed attempts within a rolling window, create a lockout row.
 */
function handleLockoutEscalation(int $userId, ?string $ip): void {
  $maxFailed = getSettingAsInt('security', 'max_failed_logins', 5);
  $lockoutByIp = getSettingAsBool('security', 'lockout_by_ip_enabled', true);

  $userFails = getFailedLoginAttemptsByUser($userId);
  $ipFails = getFailedLoginAttemptsByIp($ip);
  
  if ($userFails < $maxFailed && ($ipFails < $maxFailed || !$lockoutByIp)) return;

  if(isAccountLocked($userId, $ip)) return;

  $reason = ($userFails >= $maxFailed)
      ? "too_many_failed_logins_user"
      : "too_many_failed_logins_ip";

  lockAccount($userId, $ip, $reason, $userFails, $ipFails);
}


<?php
declare(strict_types=1);

require_once __DIR__ . '/../../bootstrap.php';
require_once __DIR__ . '/../../lib/auth/getActiveUserById.php';
require_once __DIR__ . '/../../lib/auth/logFailedAttempt.php';
require_once __DIR__ . '/../../lib/auth/isAccountLocked.php';
require_once __DIR__ . '/../../lib/auth/isMfaRequired.php';
require_once __DIR__ . '/../../lib/auth/audit.php';
require_once __DIR__ . '/../../lib/auth/createAuthSession.php';

Cors::handle('POST,OPTIONS');

$ip        = $_SERVER['REMOTE_ADDR'] ?? null;
$userAgent= $_SERVER['HTTP_USER_AGENT'] ?? null;

if(!postMethodCheck()) {
  exit;
}

$input = getPostedInput();

$identifier = trim($input['identifier'] ?? '');
$password   = $input['password'] ?? '';

if ($identifier === '' || $password === '') {
  Json::sendError('missing_credentials', HttpStatus::BAD_REQUEST);
}

$user = getActiveUserById($identifier);
if (!$user) {
    logFailedAttempt(null, $identifier, $ip);
    Json::sendError('invalid_credentials', HttpStatus::UNAUTHORIZED);
}

if (isAccountLocked($user['id'], $ip)) {
    audit($user['id'], 'login.locked', $ip, $userAgent);
    Json::sendError('account_locked', HttpStatus::LOCKED);
    exit;
}

if (!password_verify($password, $user['password_hash'])) {
    logFailedAttempt($user['id'], $identifier, $ip);
    handleLockoutEscalation($user['id'], $ip);

    audit($user['id'], 'login.failed', $ip, $userAgent);
    Json::sendError('invalid_credentials', HttpStatus::UNAUTHORIZED);
    exit;
}

if (password_needs_rehash($user['password_hash'], PASSWORD_ARGON2ID)) {
    $newHash = password_hash($password, PASSWORD_ARGON2ID);
    $upd = db()->prepare("UPDATE users SET password_hash=? WHERE id=?");
    $upd->execute([$newHash, $user['id']]);
}

$mfaRequired = isMfaRequired($user['id']);

if ($mfaRequired) {
    $challengeId = createMfaChallenge($user['id'], $ip, $userAgent);

    audit($user['id'], 'login.mfa_required', $ip, $userAgent);

    Json::sendData([
        'status'        => 'mfa_required',
        'challenge_id'  => $challengeId,
        'methods'       => getAvailableMfaMethods($user['id']),
    ], HttpStatus::OK);
}

$session = createAuthSession($user['id'], $ip, $userAgent);

db()->prepare("UPDATE users SET last_login_at = NOW() WHERE id=?")
   ->execute([$user['id']]);

audit($user['id'], 'login.success', $ip, $userAgent);

Json::sendData([
    'status'        => 'ok',
    'user' => [
        'id'       => (int)$user['id'],
        'username' => $user['username'],
        'email'    => $user['email'],
    ],
    'session' => [
        'token_id' => $session['token_id'],
        'expires' => $session['expires_at'],
    ],
], HttpStatus::OK);

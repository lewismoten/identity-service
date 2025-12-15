<?php
declare(strict_types=1);

require_once __DIR__ . '/../../bootstrap.php';
require_once __DIR__ . '/../../lib/auth/getActiveUserByIdentifier.php';
require_once __DIR__ . '/../../lib/auth/logFailedAttempt.php';
require_once __DIR__ . '/../../lib/auth/isAccountLocked.php';
require_once __DIR__ . '/../../lib/auth/isMfaRequired.php';
require_once __DIR__ . '/../../lib/auth/audit.php';
require_once __DIR__ . '/../../lib/auth/createAuthSession.php';
require_once __DIR__ . '/../../lib/auth/rehashPasswordForUserId.php';
require_once __DIR__ . '/../../lib/auth/updateLastLoginForUserId.php';

Cors::handle('POST,OPTIONS');

$ip        = $_SERVER['REMOTE_ADDR'] ?? null;
$userAgent = $_SERVER['HTTP_USER_AGENT'] ?? null;

$input = Json::getPostedInput();

$identifier = trim($input['identifier'] ?? '');
$password   = $input['password'] ?? '';

if ($identifier === '' || $password === '') {
  Json::sendError('missing_credentials', HttpStatus::BAD_REQUEST);
}

$user = getActiveUserByIdentifier($identifier);
if (!$user) {
    logFailedAttempt(null, $identifier, $ip);
    Json::sendError('invalid_credentials', HttpStatus::UNAUTHORIZED);
}

$userid = (int)$user['id'];

if (isAccountLocked($userid, $ip)) {
    audit($userid, 'login.locked', $ip, $userAgent);
    Json::sendError('account_locked', HttpStatus::LOCKED);
    exit;
}

$passwordhash = $user['password_hash'];
if (!password_verify($password, $passwordhash)) {
    logFailedAttempt($userid, $identifier, $ip);
    handleLockoutEscalation($userid, $ip);

    audit($userid, 'login.failed', $ip, $userAgent);
    Json::sendError('invalid_credentials', HttpStatus::UNAUTHORIZED);
    exit;
}

if (password_needs_rehash($passwordhash, PASSWORD_ARGON2ID)) {
    rehashPasswordForUserId($userid, $password);
}

$mfaRequired = isMfaRequired($userid);

if ($mfaRequired) {
    $challengeId = createMfaChallenge($userid, $ip, $userAgent);

    audit($userid, 'login.mfa_required', $ip, $userAgent);

    Json::sendData([
        'status'        => 'mfa_required',
        'challenge_id'  => $challengeId,
        'methods'       => getAvailableMfaMethods($userid),
    ], HttpStatus::OK);
}

$session = createAuthSession($userid, $ip, $userAgent);

updateLastLoginForUserId($userid);

audit($userid, 'login.success', $ip, $userAgent);

Json::sendData([
    'status'        => 'ok',
    'user' => [
        'id'       => $userid,
        'username' => $user['username'],
        'email'    => $user['email'],
    ],
    'session' => [
        'token_id' => $session['token_id'],
        'expires' => $session['expires_at'],
    ],
], HttpStatus::OK);

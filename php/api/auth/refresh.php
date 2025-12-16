<?php
declare(strict_types=1);

require_once __DIR__ . '/../../bootstrap.php';

Cors::handle('POST');

HttpResponse::ensureRequestId();

$ip = $_SERVER['REMOTE_ADDR'] ?? null;
$ua = $_SERVER['HTTP_USER_AGENT'] ?? null;

$in = Json::input(requirePost: true, requireJson: true, requireAcceptJson: true);

$tokenId = trim((string)($in['token_id'] ?? ''));
if ($tokenId === '') {
    Json::sendError('missing_token_id', HttpStatus::BAD_REQUEST);
}

$refresh = (string)($_COOKIE['refresh_token'] ?? '');
if ($refresh === '') {
    Json::sendError('missing_refresh_cookie', HttpStatus::UNAUTHORIZED);
}

try {
    $auth = \Auth\AuthFactory::service();
    $out  = $auth->refresh($tokenId, $refresh, $ip, $ua);

    // Set rotated refresh cookie if present
    if (($out['status'] ?? '') === 'ok' && isset($out['_cookie']['refresh_token'])) {
        $ttlDays = (int)$out['_cookie']['ttl_days'];
        HttpResponse::setRefreshTokenCookie((string)$out['_cookie']['refresh_token'], $ttlDays);
        unset($out['_cookie']);
    }

    Json::sendData($out, HttpStatus::OK);

} catch (\RuntimeException $e) {
    $key = $e->getMessage();

    // On invalid refresh, clear cookie to force clean login
    if (in_array($key, ['invalid_session', 'invalid_refresh_token', 'session_revoked_or_expired'], true)) {
        HttpResponse::clearRefreshTokenCookie();
        Json::sendError('refresh_failed', HttpStatus::UNAUTHORIZED);
    }

    Json::sendError('refresh_failed', HttpStatus::UNAUTHORIZED);

} catch (\Throwable $e) {
    Json::sendError('internal_error', HttpStatus::INTERNAL_SERVER_ERROR);
}

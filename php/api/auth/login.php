<?php
declare(strict_types=1);

require_once __DIR__ . '/../../bootstrap.php';

Cors::handle('POST');

$ip = $_SERVER['REMOTE_ADDR'] ?? null;
$ua = $_SERVER['HTTP_USER_AGENT'] ?? null;

$in = Json::input(requirePost: true, requireJson: true, requireAcceptJson: true);

$identifier = (string)($in['identifier'] ?? '');
$password   = (string)($in['password'] ?? '');

try {
    $auth = \Auth\AuthFactory::service();
    $out  = $auth->login($identifier, $password, $ip, $ua);
    if(($out['status'] ?? '') === 'ok' && isset($out['_cookie']['refresh_token'])) {
        HttpResponse::setRefreshToken(
            (string)$out['_cookie']['refresh_token'],
            (int)$out['_cookie']['ttl_days']
        );
        unset($out['_cookie']);
    }

    Json::sendData($out, HttpStatus::OK);
} catch (\DomainException $e) {
    Json::sendError($e->getMessage(), HttpStatus::BAD_REQUEST);
} catch (\RuntimeException $e) {
    $key = $e->getMessage();
    if ($key === 'account_locked') {
        Json::sendError($key, HttpStatus::LOCKED);
    }
    if ($key === 'invalid_credentials') {
        Json::sendError($key, HttpStatus::UNAUTHORIZED);
    }
    Json::sendError('auth_failed', HttpStatus::UNAUTHORIZED);
} catch (\Throwable $e) {
    Json::sendError('internal_error', HttpStatus::INTERNAL_SERVER_ERROR);
}

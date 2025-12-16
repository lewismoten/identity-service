<?php
declare(strict_types=1);

require_once __DIR__ . '/../../bootstrap.php';

Cors::handle('POST');

HttpResponse::ensureRequestId();

$ip = $_SERVER['REMOTE_ADDR'] ?? null;
$ua = $_SERVER['HTTP_USER_AGENT'] ?? null;

$in = Json::input(requirePost: true, requireJson: true, requireAcceptJson: true);

$tokenId = (string)($in['token_id'] ?? '');
if ($tokenId !== '') {
    try {
        $auth = \Auth\AuthFactory::service();
        $auth->logout($tokenId, $ip, $ua);
    } catch (\Throwable $e) {
    }
}
HttpResponse::clearRefreshTokenCookie();
Json::sendData(['status' => 'ok'], HttpStatus::OK);
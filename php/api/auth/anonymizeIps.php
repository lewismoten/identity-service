<?php
declare(strict_types=1);

require_once __DIR__ . '/../../bootstrap.php';

Cors::handle('GET');

try {
  $changed = (new \Auth\AuditService())->anonymizeIps();
  Json::sendData(['updated' => $changed], HttpStatus::OK);
} catch (\DomainException $e) {
    Json::sendError($e->getMessage(), HttpStatus::BAD_REQUEST);
} catch (\RuntimeException $e) {
    Json::sendError('anonymizeips_failed', HttpStatus::UNAUTHORIZED);
} catch (\Throwable $e) {
    Json::sendError('internal_error', HttpStatus::INTERNAL_SERVER_ERROR);
}

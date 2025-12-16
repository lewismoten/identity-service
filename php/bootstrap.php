<?php

declare(strict_types=1);

spl_autoload_register(function (string $class): void {
    $base = __DIR__ . '/lib/';
    $path = $base . str_replace('\\', '/', $class) . '.php';
    if (is_file($path)) {
        require_once $path;
    }
});

require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/lib/Db.php';
require_once __DIR__ . '/lib/HttpStatus.php';

$__crypto = new Crypto();
function crypto(): Crypto { global $__crypto; return $__crypto;}

$__epoch = new EpochTime();
function epochTime(): epochTime { global $__epoch; return $__epoch; }

try {
    $pdo = db();
} catch (\RuntimeException $e) {
    Json::sendError($e->getMessage(), HttpStatus::INTERNAL_SERVER_ERROR);
}

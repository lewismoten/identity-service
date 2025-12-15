<?php

declare(strict_types=1);
require_once __DIR__ . '/lib/HttpStatus.php';
require_once __DIR__ . '/lib/DbDate.php';
require_once __DIR__ . '/lib/EpochTime.php';
require_once __DIR__ . '/lib/Crypto.php';
require_once __DIR__ . '/lib/Json.php';
require_once __DIR__ . '/lib/Db.php';
require_once __DIR__ . '/lib/Cors.php';

$__crypto = new Crypto();

/** @return Crypto */
function crypto(): Crypto
{
    global $__crypto;
    return $__crypto;
}

<?php
declare(strict_types=1);

final class RequestContext
{
    private static ?string $requestId = null;

    public static function id(): string
    {
        if (self::$requestId !== null) return self::$requestId;

        $hdr = $_SERVER['HTTP_X_REQUEST_ID'] ?? '';
        if (is_string($hdr) && $hdr !== '' && strlen($hdr) <= 64) {
            self::$requestId = $hdr;
            return self::$requestId;
        }

        self::$requestId = crypto()->new_id();
        return self::$requestId;
    }
}

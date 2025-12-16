<?php
declare(strict_types=1);

final class HttpResponse
{
    private static bool $sentRequestId = false;

    public static function ensureRequestIdHeader(): string
    {
        $id = RequestContext::id();
        if (!headers_sent() && !self::$sentRequestId) {
            header('X-Request-Id: ' . $id);
            self::$sentRequestId = true;
        }
        return $id;
    }
    public static function output(string $data): void
    {
        echo $data;
    }
    public static function setStatusCode(int $code): void 
    {
        if (headers_sent()) return;
        http_response_code($code);
    }
    public static function allowMethods(string $methods): void 
    {
        if (headers_sent()) return;
        header("Allow: {$methods}");
    }
    public static function setContentType(string $contentType): void
    {
        if (headers_sent()) return;
        if($contentType === 'application/json') {
            $contentType .= '; charset=utf-8';
        }
        header("Content-Type: {$contentType}");
    }

    public static function noCache(): void
    {
        if (headers_sent()) return;
        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
        header('Pragma: no-cache');
        header('Expires: 0');
        header('X-Content-Type-Options: nosniff');
        // Proxy helpers
        header('Referrer-Policy: no-referrer');
        header('X-Frame-Options: DENY');
    }

    /**
     * Set a cookie in a consistent way.
     * Provide $options that match PHP's setcookie options.
     */
    public static function setCookie(string $name, string $value, array $options): void
    {
        if (headers_sent()) return;
        self::ensureRequestIdHeader();
        self::noCache();
        setcookie($name, $value, $options);
    }

    /** set refresh token cookie */
    public static function setRefreshToken(string $refreshToken, int $ttlDays): void
    {
        self::_setRefreshToken($refreshToken, epochTime()->inDays($ttlDays));
    }

    /** clear refresh token cookie */
    public static function clearRefreshToken(): void
    {
        self::_setRefreshToken('', 1);
    }
    private static function _setRefreshToken(string $token, int $expires): void
    {
        $sameSite = Settings::str(\SettingKeys::COOKIES_REFRESH_SAMESITE, 'Lax'); // 'Lax' or 'None'
        $path     = Settings::str(\SettingKeys::COOKIES_REFRESH_PATH, '/api/auth');

        self::setCookie('refresh_token', $token, [
            'expires'  => max(1, $expires),
            'path'     => $path,
            'secure'   => true,
            'httponly' => true,
            'samesite' => $sameSite,
        ]);
    }
}

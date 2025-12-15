<?php
declare(strict_types=1);

final class HttpStatus
{
    // 2xx
    public const OK = 200;
    public const CREATED = 201;
    public const NO_CONTENT = 204;

    // 4xx
    public const BAD_REQUEST = 400;
    public const UNAUTHORIZED = 401;
    public const FORBIDDEN = 403;
    public const NOT_FOUND = 404;
    public const METHOD_NOT_ALLOWED = 405;
    public const NOT_ACCEPTABLE = 406;
    public const CONFLICT = 409;
    public const GONE = 410;
    public const UNSUPPORTED_MEDIA_TYPE = 415;
    public const UNPROCESSABLE_ENTITY = 422;
    public const LOCKED = 423;
    public const TOO_MANY_REQUESTS = 429;

    // 5xx
    public const INTERNAL_SERVER_ERROR = 500;
    public const SERVICE_UNAVAILABLE = 503;
}
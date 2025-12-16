<?php 
require_once __DIR__ . '/HttpStatus.php';

final class Json
{
  private static bool $parsed = false;
  private static array $cached = [];

  public static function input(
    bool $requirePost = true,
    bool $requireJson = true,
    bool $requireAcceptJson = true
  ): array { 
    if(self::$parsed) return self::$cached;

    if($requirePost) {
      self::requireMethod('POST');
    }
    if ($requireAcceptJson) {
      self::requireAcceptJson();
    }
    if ($requireJson) {
      self::requireJsonContentTypeIfBodyPresent();
    }
    $raw = file_get_contents('php://input');
    if($raw === false) {
      self::sendError('read_failed', HttpStatus::BAD_REQUEST);
    }
    $raw = trim($raw);
    if($raw === '') {
      self::$parsed = true;
      self::$cached = [];
      return self::$cached;
    }
    try {
      /** @var array $data */
      $data = json_decode($raw, true, 512, JSON_THROW_ON_ERROR);
    } catch(\JsonException $e) {
      self::sendError('invalid_json', HttpStatus::BAD_REQUEST);
    }
    if(!is_array($data)) {
      self::sendError('json_object_required', HttpStatus::BAD_REQUEST);
    }
    self::$parsed = true;
    self::$cached = $data;
    return self::$cached;
  }
  public static function requireAcceptJson(): void
  {
    $accept = $_SERVER['HTTP_ACCEPT'] ?? '*/*';
    // Accept */*, application/json, application/*+json
    if (
        $accept === '*/*' ||
        str_contains($accept, 'application/json') ||
        preg_match('#application/.+\+json#', $accept)
    ) {
        return;
    }

    self::sendError(
        'not_acceptable',
        HttpStatus::NOT_ACCEPTABLE,
        ['expected' => 'application/json']
    );
  }
  /**
   * Enforces JSON Content-Type only if a body is present.
   * This avoids 415 for empty POSTs (some clients send no body).
   */
  private static function requireJsonContentTypeIfBodyPresent(): void
  {
      $len = $_SERVER['CONTENT_LENGTH'] ?? null;
      $hasBody = $len !== null && (int)$len > 0;
      if (!$hasBody) return;
      self::requireJsonContentType();
  }
   /**
     * Enforce Content-Type: application/json (allows charset parameter).
     */
  public static function requireJsonContentType(): void {
    $contentType = $_SERVER['CONTENT_TYPE'] ?? $_SERVER['HTTP_CONTENT_TYPE'] ?? '';
    $contentType = strtolower(trim(explode(';', $ct, 2)[0]));
    if ($contentType === 'application/json') return;
    self::sendError('unsupported_media_type', HttpStatus::UNSUPPORTED_MEDIA_TYPE, [
      'expected' => 'application/json',
      'received' => $contentType ?: null,
    ]);
  }
  public static function requireMethod(string $method): void {
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === $method) return;
    \HttpResponse::allowMethods($method);
    self::sendError('method_not_allowed', HttpStatus::METHOD_NOT_ALLOWED);
  }
  public static function sendError(
    string $error_key = 'unknown_error', 
    int $status_code = HttpStatus::INTERNAL_SERVER_ERROR,
    array $extra = []
  ): void {
    self::sendData(
      array_merge(['error' => $error_key], $extra),
      $status_code
    );
  }
  public static function sendData(
    mixed $data, 
    int $status_code = HttpStatus::OK
  ): void {

    \HttpResponse::setContentType('application/json');
    \HttpResponse::noCache();
    \HttpResponse::setStatusCode($status_code);
    \HttpResponse::output(
      json_encode(
        $data,
        JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE
      )
    );
    exit;
  }
}
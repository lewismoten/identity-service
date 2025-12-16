<?php
require_once __DIR__ . '/HttpStatus.php';

declare(strict_types=1);

final class Cors
{
  private static function cleanAndValidateMethods(string $methodString): array
  {
    $allowed = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];
    $methods = array_map(function($method) {
        return strtoupper(trim($method));
    }, explode(',', $methodString));
    $uniqueMethods = array_unique($methods);
    $filtered = array_filter($uniqueMethods, function($method) use ($allowed) {
      if($method === 'OPTIONS') return false;
      if(in_array($method, $allowed)) return true;
      throw new InvalidArgumentException('cors_unexpected_method');
    });
    $filtered = array_values($filtered);
    if (empty($filtered)) {
        throw new InvalidArgumentException('cors_missing_method');
    }
    $filtered[] = 'OPTIONS';
    return implode(',', $filtered);
  }
  public static function handle(string $allowedMethods = 'GET,POST,PUT,PATCH,DELETE'): void
  {
    $methods = self::cleanAndValidateMethods($allowedMethods);
    $origin = $_SERVER['HTTP_ORIGIN'] ?? null;
    if (!$origin) return;
    if($origin === 'null') {
      // file:// or sandboxed iframes
      if(($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'OPTIONS') {
        http_response_code(HttpStatus::NO_CONTENT);
        exit;
      }
      return;
    }
    $row = self::lookupOrigin($origin);
    if (!$row) {
      if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'OPTIONS') {
        http_response_code(HttpStatus::NO_CONTENT);
        exit;
      }
      return;
    }

    header('Vary: Origin');
    header("Access-Control-Allow-Origin: {$origin}");
    header('Access-Control-Allow-Methods: ' . $methods);

    $allowHeaders = 'Content-Type, Authorization, X-Requested-With, X-Request-Id';
    $reqHeaders = $_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'] ?? '';
    if ($reqHeaders !== '') {
      // Verify reqHeaders is subset of allowHeaders
    }
    header('Access-Control-Allow-Headers: '.$allowHeaders);
    header('Vary: Access-Control-Request-Headers');
    header('Access-Control-Expose-Headers: Content-Type, X-Request-Id');
    if ((int)$row['allow_credentials'] === 1) {
        header('Access-Control-Allow-Credentials: true');
    }
    header('Access-Control-Max-Age: 300');
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'OPTIONS') {
        http_response_code(HttpStatus::NO_CONTENT);
        exit;
    }
  }

  private static function lookupOrigin(string $origin): ?array
  {
    $stmt = db()->prepare("
        SELECT origin, allow_credentials
        FROM cors_allowed_origins
        WHERE origin = ? AND is_enabled = 1
        LIMIT 1
    ");
    $stmt->execute([$origin]);
    $row = $stmt->fetch(\PDO::FETCH_ASSOC);
    return $row ?: null;
  }
}

<?php
require_once __DIR__ . '/HttpStatus.php';

declare(strict_types=1);

final class Cors
{
  public static function handle(string $allowedMethods = 'GET,POST,PUT,PATCH,DELETE,OPTIONS'): void
  {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? null;
    if (!$origin) return;
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
    header('Access-Control-Allow-Methods: ' . $allowedMethods);

    $reqHeaders = $_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'] ?? '';
    if ($reqHeaders !== '') {
        header('Access-Control-Allow-Headers: ' . $reqHeaders);
        header('Vary: Access-Control-Request-Headers');
    } else {
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
    }
    header('Access-Control-Expose-Headers: Content-Type');
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

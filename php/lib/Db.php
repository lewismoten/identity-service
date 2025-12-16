<?php
declare(strict_types=1);

final class Db
{
    private static ?\PDO $pdo = null;
    private static ?array $config = null;
    public static function loadConfig(): array 
    {

        if (self::$config !== null) {
            return self::$config;
        }

        $configPath = dirname(__DIR__) . '/config/database.php';

        if (!is_file($configPath)) {
          throw new \RuntimeException('database_config_missing');
        }
        $cfg = require $configPath;
        if (!is_array($cfg)) {
          http_response_code(HttpStatus::INTERNAL_SERVER_ERROR);
          throw new \RuntimeException('database_config_invalid');
        }

        self::$config = [
            'host'     => getenv('DB_HOST') ?: $cfg['host'] ?? 'localhost',
            'port'     => getenv('DB_PORT') ?: $cfg['port'] ?? '3306',
            'database' => getenv('DB_NAME') ?: $cfg['database'] ?? 'identity',
            'username' => getenv('DB_USER') ?: $cfg['username'] ?? 'identity_user',
            'password' => getenv('DB_PASS') ?: $cfg['password'] ?? '',
            'charset'  => $cfg['charset'] ?? 'utf8mb4',
            'timezone' => $cfg['timezone'] ?? '+00:00',
        ];

        return self::$config;

    }
    public static function get(): \PDO
    {
        if (self::$pdo instanceof \PDO) {
            return self::$pdo;
        }

        $cfg = self::loadConfig();

        $dsn = sprintf(
            'mysql:host=%s;port=%s;dbname=%s;charset=%s',
            $cfg['host'],
            $cfg['port'],
            $cfg['database'],
            $cfg['charset']
        );

        $options = [
            \PDO::ATTR_ERRMODE            => \PDO::ERRMODE_EXCEPTION,
            \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
            \PDO::ATTR_EMULATE_PREPARES   => false
        ];

        try {
            self::$pdo = new \PDO(
              $dsn,
              $cfg['username'],
              $cfg['password'],
              $options
            );
            $stmt = self::$pdo->prepare("SET time_zone = ?");
            $stmt->execute([$cfg['timezone']]);

        } catch (\PDOException $e) {
          throw new \RuntimeException('database_unavailable');
        }

        return self::$pdo;
    }
}

/**
 * Database
 * @return PDO
 */
function db(): \PDO
{
    return Db::get();
}

<?php
declare(strict_types=1);

//$apcuEnabled = function_exists('apcu_fetch') && filter_var(ini_get('apc.enabled'), FILTER_VALIDATE_BOOL);
// 30-300 sec cache if APCu is available

final class Settings
{
    /** @var array<string, string|null> */
    private static array $cache = [];

    public static function get(string $key, ?string $default = null): ?string
    {
        if (array_key_exists($key, self::$cache)) return self::$cache[$key];

        [$category, $name] = self::split($key);

        $stmt = db()->prepare("
            SELECT value
              FROM system_settings
             WHERE category = ?
               AND name = ?
             LIMIT 1
        ");
        $stmt->execute([$category, $name]);
        $row = $stmt->fetch();

        $val = $row && isset($row['value']) ? (string)$row['value'] : $default;
        self::$cache[$key] = $val;

        return $val;
    }
    public static function str(string $key, string $default): string
    {
        return (self::get($key, $default) ?? $default);
    }
    public static function int(string $key, int $default): int
    {
        return (int)(self::get($key, (string)$default) ?? $default);
    }
    public static function bool(string $key, bool $default): bool
    {
      $trueValues = ['1','true','yes','on'];
        return in_array(
          strtolower(trim(
            (string)self::get($key, $default ? '1' : '0')
          )), 
          $trueValues, 
          true
        );
    }
    public static function json(string $key, array $default = []): array
    {
        $raw = self::get($key, null);
        if ($raw === null || trim($raw) === '') return $default;
        $val = json_decode($raw, true);
        return is_array($val) ? $val : $default;
    }
    private static function split(string $key): array
    {
        $pos = strpos($key, '.');
        if ($pos === false) {
            throw new InvalidArgumentException("Invalid setting key: {$key}");
        }
        return [substr($key, 0, $pos), substr($key, $pos + 1)];
    }
    /**
     * Call if settings are updated
     */
    public static function clearCache(): void
    {
        self::$cache = [];
    }
}

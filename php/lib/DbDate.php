<?php
declare(strict_types=1);

final class DbDate
{
    private const FORMAT = 'Y-m-d H:i:s';
    private const TZ = 'UTC';

    private static function base(): \DateTimeImmutable 
    {
        return (new \DateTimeImmutable('now', new \DateTimeZone(self::TZ)));
    }
    private static bump(int $value, string $unit): string {
        if (!in_array($unit, ['seconds','minutes','days'], true)) {
            throw new InvalidArgumentException('Invalid time unit');
        }
        $sign = ($value >= 0 ? "+" : "");
        return "{$sign}{$value} {$unit}";
    }
    public static function inSeconds(int $seconds): string
    {
        return self::base()
            ->modify(self::bump($seconds, 'seconds'))
            ->format(self::FORMAT);
    }

    public static function inMinutes(int $minutes): string
    {
        return self::base()
            ->modify(self::bump($minutes, 'minutes'))
            ->format(self::FORMAT);
    }

    public static function inDays(int $days): string
    {
        return self::base()
            ->modify(self::bump($days, 'days'))
            ->format(self::FORMAT);
    }

    public static function now(): string
    {
        return self::base()
            ->format(self::FORMAT);
    }

    public static function fromTimestamp(int $ts): string
    {
        return (new \DateTimeImmutable("@$ts"))
            ->setTimezone(new \DateTimeZone(self::TZ))
            ->format(self::FORMAT);
    }
}
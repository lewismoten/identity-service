<?php 
final class EpochTime
{
    public static function now(): int { return time(); }
    public static function inSeconds(int $s): int { return time() + $s; }
    public static function inMinutes(int $m): int { return time() + ($m * 60); }
    public static function inHours(int $h): int { return time() + ($m * 3600); }
    public static function inDays(int $d): int { return time() + ($d * 86400); }
}
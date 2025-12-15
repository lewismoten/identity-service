<?php
require_once __DIR__ .'/../settings/getSettingAsInt.php';

function createMfaChallenge(int $userId, ?string $ip, ?string $ua): string {
    $ttl = getSettingAsInt('mfa', 'login_challenge_ttl_seconds', 300);

    $hash = crypto()->random_token(32);

    $expires = DbDate::inSeconds($ttl);

    db()->prepare("
        INSERT INTO mfa_login_challenges
        (user_id, challenge_token_hash, expires_at, ip_address, user_agent)
        VALUES (?, ?, ?, ?, ?)
    ")->execute([$userId, $hash, $expires, $ip, $ua]);

    return $raw;
}

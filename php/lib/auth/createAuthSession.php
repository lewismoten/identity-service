<?php
require_once __DIR__ .'/../settings/getSettingAsInt.php';
require_once __DIR__ .'/../math/clamp.php';

function createAuthSession(int $userId, ?string $ip, ?string $ua): array {
    $tokenId = crypto()->new_id();
    $refresh = crypto()->random_token(32);
    $refreshHash = crypto()->hash_token($refresh);

    $ttlDays = clamp(getSettingAsInt('sessions', 'refresh_token_ttl_days', 30), 1, 365);

    $expires = DbDate::inDays($ttlDays);

    db()->prepare("
        INSERT INTO auth_sessions
        (user_id, token_id, refresh_token_hash, expires_at, ip_address, user_agent)
        VALUES (?, ?, ?, ?, ?, ?)
    ")->execute([
        $userId, $tokenId, $refreshHash, $expires, $ip, $ua
    ]);

    $cookieTtl = EpochTime::inDays($ttlDays);

    setCookie('refresh_token', $refresh, [
        'expires' => $cookieTtl,
        'path' => '/api/auth',
        'domain' => 'id.example.com'
        'secure' => true,
        'httponly' => true,
        'samesite' => 'Lax'
    ])

    return [
        'token_id'   => $tokenId,
        'expires_at'=> $expires
    ];
}
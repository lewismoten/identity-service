<?php
declare(strict_types=1);

namespace Auth;

final class HmacKeyStore implements JwtKeyStore
{
    public function activeKid(string $alg): ?string
    {
        // optional: keep a "kid" for HMAC rotation too
        return Settings::str('jwt.hmac_kid', 'hmac-1');
    }

    public function sign(string $alg, ?string $kid, string $signingInput): string
    {
        if ($alg !== 'HS256') {
            throw new \RuntimeException('jwt_alg_not_supported');
        }
        $secret = Settings::str('jwt.hmac_secret', '');
        if ($secret === '') throw new \RuntimeException('jwt_missing_secret');

        return hash_hmac('sha256', $signingInput, $secret, true);
    }

    public function verify(string $alg, ?string $kid, string $signingInput, string $signature): bool
    {
        $expected = $this->sign($alg, $kid, $signingInput);
        return hash_equals($expected, $signature);
    }
}

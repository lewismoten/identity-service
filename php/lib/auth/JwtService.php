<?php
declare(strict_types=1);

namespace Auth;

final class JwtService
{
    public function __construct(
        private JwtKeyStore $keys
    ) {}

    /**
     * Issue an access token.
     */
    public function issueAccessToken(
        int $userId,
        string $sessionTokenId,
        array $claims = [],
        array $scopes = []
    ): string {
        $alg  = Settings::str(SettingKeys::JWT_SIGNING_ALGORITHM, 'HS256');
        $iss  = Settings::str(SettingKeys::JWT_ISSUER, 'https://id.example.com');
        $aud  = Settings::str(SettingKeys::JWT_AUDIENCE, 'https://app.example.com');
        $ttl  = Settings::int(SettingKeys::JWT_ACCESS_TOKEN_TTL_SECONDS, 900);

        $now  = time();
        $exp  = $now + $ttl;

        $header = [
            'typ' => 'JWT',
            'alg' => $alg,
        ];

        $kid = $this->keys->activeKid($alg);
        if ($kid !== null) {
            $header['kid'] = $kid;
        }

        $payload = array_merge([
            'iss' => $iss,
            'aud' => $aud,
            'iat' => $now,
            'nbf' => $now,
            'exp' => $exp,
            'sub' => (string)$userId,
            'sid' => $sessionTokenId,
            'scp' => $scopes,
        ], $claims);

        return $this->encode($header, $payload);
    }

    /**
     * Verify JWT signature + standard claims (iss/aud/exp/nbf).
     * Returns payload array on success; throws RuntimeException on failure.
     */
    public function verify(string $jwt): array
    {
        $parts = explode('.', $jwt);
        if (count($parts) !== 3) {
            throw new \RuntimeException('jwt_malformed');
        }

        [$h64, $p64, $s64] = $parts;

        $header  = $this->jsonDecode($this->b64urlDecode($h64), 'jwt_header_invalid');
        $payload = $this->jsonDecode($this->b64urlDecode($p64), 'jwt_payload_invalid');

        $alg = (string)($header['alg'] ?? '');
        if ($alg === '') {
            throw new \RuntimeException('jwt_missing_alg');
        }

        $kid = isset($header['kid']) ? (string)$header['kid'] : null;

        $signingInput = $h64 . '.' . $p64;
        $sig = $this->b64urlDecode($s64);

        if (!$this->keys->verify($alg, $kid, $signingInput, $sig)) {
            throw new \RuntimeException('jwt_bad_signature');
        }

        $this->validateClaims($payload);

        return $payload;
    }

    public function bearerFromRequest(): ?string
    {
        $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
        if (!is_string($auth) || $auth === '') return null;
        if (stripos($auth, 'Bearer ') !== 0) return null;
        return trim(substr($auth, 7));
    }

    private function encode(array $header, array $payload): string
    {
        $h = $this->b64urlEncode($this->jsonEncode($header));
        $p = $this->b64urlEncode($this->jsonEncode($payload));

        $signingInput = $h . '.' . $p;

        $alg = (string)$header['alg'];
        $kid = isset($header['kid']) ? (string)$header['kid'] : null;

        $sig = $this->keys->sign($alg, $kid, $signingInput);
        $s   = $this->b64urlEncode($sig);

        return $signingInput . '.' . $s;
    }

    private function validateClaims(array $payload): void
    {
        $iss  = Settings::str(SettingKeys::JWT_ISSUER, 'https://id.example.com');
        $aud  = Settings::str(SettingKeys::JWT_AUDIENCE, 'https://app.example.com');
        $skew = Settings::int(SettingKeys::JWT_CLOCK_SKEW_SECONDS, 60);

        $now = time();

        if (($payload['iss'] ?? null) !== $iss) {
            throw new \RuntimeException('jwt_bad_issuer');
        }

        $audClaim = $payload['aud'] ?? null;
        $audOk = ($audClaim === $aud) || (is_array($audClaim) && in_array($aud, $audClaim, true));
        if (!$audOk) {
            throw new \RuntimeException('jwt_bad_audience');
        }

        $exp = isset($payload['exp']) ? (int)$payload['exp'] : 0;
        if ($exp <= 0 || $now > ($exp + $skew)) {
            throw new \RuntimeException('jwt_expired');
        }

        if (isset($payload['nbf'])) {
            $nbf = (int)$payload['nbf'];
            if ($now + $skew < $nbf) {
                throw new \RuntimeException('jwt_not_yet_valid');
            }
        }
    }

    private function jsonEncode(array $v): string
    {
        return json_encode($v, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }

    private function jsonDecode(string $json, string $errKey): array
    {
        try {
            $v = json_decode($json, true, 512, JSON_THROW_ON_ERROR);
        } catch (\Throwable) {
            throw new \RuntimeException($errKey);
        }
        if (!is_array($v)) throw new \RuntimeException($errKey);
        return $v;
    }

    private function b64urlEncode(string $bin): string
    {
        return rtrim(strtr(base64_encode($bin), '+/', '-_'), '=');
    }

    private function b64urlDecode(string $b64): string
    {
        $pad = strlen($b64) % 4;
        if ($pad) $b64 .= str_repeat('=', 4 - $pad);
        return base64_decode(strtr($b64, '-_', '+/')) ?: '';
    }
}

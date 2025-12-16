<?php
declare(strict_types=1);

namespace Auth;

final class DbRsaKeyStore implements JwtKeyStore
{
    public function activeKid(string $alg): ?string
    {
        if ($alg !== 'RS256') return null;

        $stmt = db()->prepare("
            SELECT kid
              FROM jwt_signing_keys
             WHERE alg = 'RS256'
               AND is_active = 1
               AND active_from <= NOW()
               AND (retired_at IS NULL OR retired_at > NOW())
             ORDER BY active_from DESC
             LIMIT 1
        ");
        $stmt->execute();
        $kid = $stmt->fetchColumn();
        return $kid ? (string)$kid : null;
    }

    public function sign(string $alg, ?string $kid, string $signingInput): string
    {
        if ($alg !== 'RS256') throw new \RuntimeException('jwt_alg_not_supported');
        if ($kid === null || $kid === '') {
            $kid = $this->activeKid($alg);
        }
        if (!$kid) throw new \RuntimeException('jwt_missing_kid');

        $row = $this->loadKeyRow($kid, requirePrivate: true);

        $privPem = $this->decryptPrivateKey($row['private_key_enc'], $row['private_key_nonce'], $row['private_key_kid']);
        $priv = openssl_pkey_get_private($privPem);
        if ($priv === false) throw new \RuntimeException('jwt_private_key_invalid');

        $sig = '';
        $ok = openssl_sign($signingInput, $sig, $priv, OPENSSL_ALGO_SHA256);
        if (!$ok) throw new \RuntimeException('jwt_sign_failed');

        return $sig;
    }

    public function verify(string $alg, ?string $kid, string $signingInput, string $signature): bool
    {
        if ($alg !== 'RS256') return false;
        if ($kid === null || $kid === '') return false;

        $row = $this->loadKeyRow($kid, requirePrivate: false);

        $pub = openssl_pkey_get_public($row['public_key_pem']);
        if ($pub === false) return false;

        return openssl_verify($signingInput, $signature, $pub, OPENSSL_ALGO_SHA256) === 1;
    }

    private function loadKeyRow(string $kid, bool $requirePrivate): array
    {
        $cols = $requirePrivate
            ? "kid, alg, public_key_pem, private_key_enc, private_key_nonce, private_key_kid"
            : "kid, alg, public_key_pem";

        $stmt = db()->prepare("
            SELECT {$cols}
              FROM jwt_signing_keys
             WHERE kid = ?
               AND is_active = 1
             LIMIT 1
        ");
        $stmt->execute([$kid]);
        $row = $stmt->fetch();
        if (!$row) throw new \RuntimeException('jwt_key_not_found');
        return $row;
    }

    private function decryptPrivateKey(string $cipher, string $nonce, ?string $kekKid): string
    {
        // KEK = key-encryption-key. Store it outside DB (config/env).
        // You can rotate KEKs too by kid.
        $kek = Settings::str('jwt.kek_' . ($kekKid ?: 'default'), '');
        if ($kek === '') throw new \RuntimeException('jwt_missing_kek');

        $key = sodium_hex2bin($kek); // recommend storing KEK as hex
        $plain = sodium_crypto_secretbox_open($cipher, $nonce, $key);
        if ($plain === false) throw new \RuntimeException('jwt_kek_decrypt_failed');

        return $plain;
    }
}

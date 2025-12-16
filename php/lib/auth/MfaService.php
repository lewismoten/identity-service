<?php
declare(strict_types=1);

namespace Auth;

use RuntimeException;

final class MfaService
{
    public function __construct(
        private AuditService $audit
    ) {}

    public function isRequired(int $userId): bool
    {
        if (!Settings::bool(\SettingKeys::MFA_ALLOW_TOTP, true)) {
            return false;
        }

        // User has at least one enabled MFA method
        $stmt = db()->prepare("
            SELECT 1
              FROM mfa_methods
             WHERE user_id = ?
               AND is_enabled = 1
             LIMIT 1
        ");
        $stmt->execute([$userId]);
        return (bool)$stmt->fetchColumn();
    }

    /**
     * Return enabled MFA methods for UI selection
     */
    public function getAvailableMethods(int $userId): array
    {
        $stmt = db()->prepare("
            SELECT method, label
              FROM mfa_methods
             WHERE user_id = ?
               AND is_enabled = 1
             ORDER BY sort_order ASC
        ");
        $stmt->execute([$userId]);

        $out = [];
        foreach ($stmt->fetchAll() as $row) {
            $out[] = [
                'method' => $row['method'],   // totp | sms | passkey | backup_code
                'label'  => $row['label'],
            ];
        }
        return $out;
    }

    /* ------------------------------------------------------------
       Login challenge lifecycle
       ------------------------------------------------------------ */

    public function createChallenge(int $userId, ?string $ip, ?string $ua): string
    {
        $challengeId = crypto()->new_id();
        $expiresAt   = DbDate::inMinutes(
            Settings::int(\SettingKeys::MFA_CHALLENGE_TTL_MINUTES, 5)
        );

        db()->prepare("
            INSERT INTO mfa_challenges
              (challenge_id, user_id, expires_at, ip_address, user_agent)
            VALUES
              (?, ?, ?, ?, ?)
        ")->execute([$challengeId, $userId, $expiresAt, $ip, $ua]);

        $this->audit->log(
            $userId,
            AuditEvents::MFA_CHALLENGE_SENT,
            $ip,
            $ua,
            null,
            null,
            ['challenge_id' => $challengeId]
        );

        return $challengeId;
    }

    private function getChallenge(string $challengeId): array
    {
        $stmt = db()->prepare("
            SELECT *
              FROM mfa_challenges
             WHERE challenge_id = ?
               AND used_at IS NULL
               AND expires_at > NOW()
             LIMIT 1
        ");
        $stmt->execute([$challengeId]);
        $row = $stmt->fetch();

        if (!$row) {
            throw new RuntimeException('invalid_or_expired_challenge');
        }
        return $row;
    }

    /* ------------------------------------------------------------
       Verification entry point
       ------------------------------------------------------------ */

    public function verify(
        string $challengeId,
        string $method,
        string $code,
        ?string $ip,
        ?string $ua
    ): int {
        $challenge = $this->getChallenge($challengeId);
        $userId    = (int)$challenge['user_id'];

        $ok = match ($method) {
            'totp'        => $this->verifyTotp($userId, $code),
            'backup_code' => $this->verifyBackupCode($userId, $code),
            default       => throw new RuntimeException('unsupported_mfa_method'),
        };

        if (!$ok) {
            $this->audit->log(
                $userId,
                AuditEvents::MFA_CHALLENGE_FAIL,
                $ip,
                $ua,
                null,
                null,
                ['method' => $method]
            );
            throw new RuntimeException('mfa_failed');
        }

        // Mark challenge as used
        db()->prepare("
            UPDATE mfa_challenges
               SET used_at = NOW()
             WHERE challenge_id = ?
             LIMIT 1
        ")->execute([$challengeId]);

        $this->audit->log(
            $userId,
            AuditEvents::MFA_CHALLENGE_OK,
            $ip,
            $ua,
            null,
            null,
            ['method' => $method]
        );

        return $userId;
    }

    /* ------------------------------------------------------------
       TOTP
       ------------------------------------------------------------ */

    private function verifyTotp(int $userId, string $code): bool
    {
        $stmt = db()->prepare("
            SELECT secret_enc, secret_nonce, last_used_step
              FROM user_totp
             WHERE user_id = ?
               AND is_enabled = 1
             LIMIT 1
        ");
        $stmt->execute([$userId]);
        $row = $stmt->fetch();

        if (!$row) return false;

        $secret = $this->decryptTotpSecret(
            $row['secret_enc'],
            $row['secret_nonce']
        );

        $period = Settings::int(\SettingKeys::MFA_TOTP_PERIOD_SECONDS, 30);
        $window = Settings::int(\SettingKeys::MFA_TOTP_WINDOW, 1);
        $digits = Settings::int(\SettingKeys::MFA_TOTP_DIGITS, 6);

        $nowStep = intdiv(time(), $period);

        for ($i = -$window; $i <= $window; $i++) {
            $step = $nowStep + $i;
            if ($row['last_used_step'] !== null && $step <= (int)$row['last_used_step']) {
                continue; // replay protection
            }

            if ($this->totpAt($secret, $step, $digits) === $code) {
                db()->prepare("
                    UPDATE user_totp
                       SET last_used_step = ?
                     WHERE user_id = ?
                ")->execute([$step, $userId]);
                return true;
            }
        }
        return false;
    }

    /* ------------------------------------------------------------
       Backup codes
       ------------------------------------------------------------ */

    private function verifyBackupCode(int $userId, string $code): bool
    {
        $hash = crypto()->hash_bin($code);

        $stmt = db()->prepare("
            SELECT id
              FROM user_backup_codes
             WHERE user_id = ?
               AND used_at IS NULL
               AND code_hash = ?
             LIMIT 1
        ");
        $stmt->execute([$userId, $hash]);
        $row = $stmt->fetch();

        if (!$row) return false;

        db()->prepare("
            UPDATE user_backup_codes
               SET used_at = NOW()
             WHERE id = ?
             LIMIT 1
        ")->execute([$row['id']]);

        return true;
    }

    /* ------------------------------------------------------------
       TOTP helpers
       ------------------------------------------------------------ */

    private function totpAt(string $secret, int $step, int $digits): string
    {
        $binStep = pack('N*', 0) . pack('N*', $step);
        $hash    = hash_hmac('sha1', $binStep, $secret, true);
        $offset  = ord(substr($hash, -1)) & 0x0F;
        $trunc   = unpack('N', substr($hash, $offset, 4))[1] & 0x7fffffff;

        $mod = 10 ** $digits;
        return str_pad((string)($trunc % $mod), $digits, '0', STR_PAD_LEFT);
    }

    private function decryptTotpSecret(string $cipher, string $nonce): string
    {
        // Example using libsodium (recommended)
        $key = sodium_hex2bin(Settings::str(\SettingKeys::MFA_TOTP_SECRET_KEY));
        $plain = sodium_crypto_secretbox_open($cipher, $nonce, $key);

        if ($plain === false) {
            throw new RuntimeException('totp_secret_decrypt_failed');
        }
        return $plain;
    }
}

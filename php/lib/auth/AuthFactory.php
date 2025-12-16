<?php
declare(strict_types=1);

namespace Auth;

final class AuthFactory
{
    public static function service(): AuthService
    {
        $users    = new UserRepository();
        $audit    = new AuditService();
        $lockouts = new LockoutService($audit);
        $password = new PasswordService();
        $sessions = new SessionService();
        $mfa      = new MfaService();

        return new AuthService($users, $lockouts, $audit, $sessions, $mfa, $password);
    }
    public static function jwt(): \Auth\JwtService
    {
        $alg = Settings::str('jwt.signing_algorithm', 'HS256');
        $keys = ($alg === 'RS256')
        ? new \Auth\DbRsaKeyStore()
        : new \Auth\HmacKeyStore();
        return new \Auth\JwtService($keys)
    }
}

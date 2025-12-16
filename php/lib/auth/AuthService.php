<?php
declare(strict_types=1);

namespace Auth;
use Auth\AuditEvents;

final class AuthService
{
    public function __construct(
        private UserRepository $users,
        private LockoutService $lockouts,
        private AuditService $audit,
        private SessionService $sessions,
        private MfaService $mfa,
        private PasswordService $passwords
    ) {}

    /**
     * @return array{status:string, user?:array, session?:array, challenge_id?:string, methods?:array}
     */
    public function login(string $identifier, string $password, ?string $ip, ?string $ua): array
    {
        $identifier = trim($identifier);
        if ($identifier === '' || $password === '') {
            throw new \DomainException('missing_credentials');
        }

        $user = $this->users->getActiveByIdentifier($identifier);

        if (!$user) {
            $this->lockouts->logFailedAttempt(null, $identifier, $ip);
            throw new \RuntimeException('invalid_credentials'); // map to 401
        }

        $userId = (int)$user['id'];

        if ($this->lockouts->isLocked($userId, $ip)) {
            $this->audit->log($userId, AuditEvents::LOGIN_LOCKED, $ip, $ua);
            throw new \RuntimeException('account_locked'); // map to 423
        }

        $passwordHash = (string)$user['password_hash'];

        if (!$this->passwords->verify($password, $passwordHash)) {
            $this->lockouts->logFailedAttempt($userId, $identifier, $ip);
            $this->lockouts->handleEscalation($userId, $ip);
            $this->audit->log($userId, AuditEvents::LOGIN_FAILED, $ip, $ua);
            throw new \RuntimeException('invalid_credentials'); // map to 401
        }

        if ($this->passwords->needsRehash($passwordHash)) {
            $this->passwords->rehashForUserId($userId, $password);
        }

        if ($this->mfa->isRequired($userId)) {
            $challengeId = $this->mfa->createChallenge($userId, $ip, $ua);
            $this->audit->log($userId, AuditEvents::LOGIN_MFA_REQUIRED, $ip, $ua);

            return [
                'status'       => 'mfa_required',
                'challenge_id' => $challengeId,
                'methods'      => $this->mfa->getAvailableMethods($userId),
            ];
        }

        $session = $this->sessions->create($userId, $ip, $ua);
        $this->users->touchLastLogin($userId);
        $this->audit->log($userId, AuditEvents::LOGIN_SUCCESS, $ip, $ua);

        return [
            'status' => 'ok',
            'user' => [
                'id'       => $userId,
                'username' => $user['username'],
                'email'    => $user['email'],
            ],
            'session' => [
                'token_id' => $session['token_id'],
                'expires'  => $session['expires_at'],
            ],
            '_cookie' => [
              'refresh_token' => $session['refresh_token'],
              'ttl_days'      => \Settings::int(\SettingKeys::SESSIONS_REFRESH_TTL_DAYS, 30),
              'path'          => '/api/auth'
            ]
        ];
    }

    public function refresh(string $tokenId, string $refreshToken, ?string $ip, ?string $ua): array
    {
        $result = $this->sessions->refresh($tokenId, $refreshToken, $ip, $ua);

        $sessionTokenId = $result['token_id'];
        $sessionId = $result['session_id'];
        $userId = $result['user_id'] ?? null;
        $expiresAt = $result['expires_at'];
        $refreshToken = $result['refresh_token'];

        $jwt = \Auth\AuthFactory::jwt();
        $accessJwt = $jwt->issueAccessToken($userId, $sessionTokenId, claims: [], scopes: $scopes);

        $this->audit->log(
            $userId,
            AuditEvents::SESSION_REFRESHED,
            $ip,
            $ua,
            $sessionId ?? null,
            null,
            ['token_id' => $sessionTokenId]
        );

        return [
            'status' => 'ok',
            'session' => [
                'token_id' => $sessionTokenId,
                'expires'  => $expiresAt,
            ],
            'access_token' => $accessJwt,
            '_cookie' => [
                'refresh_token' => $refreshToken,
                'ttl_days'      => Settings::int(\SettingKeys::SESSIONS_REFRESH_TTL_DAYS, 30),
            ],
        ];
    }
    public function logout(
        ?string $tokenId,
        ?string $refreshToken,
        ?string $ip,
        ?string $ua,
        ?int $actorUserId = null
    ): void {
        if($tokenId === null) return;
        if($tokenId === '') return;
        $revoked = $this->sessions->revokeByTokenId($tokenId);
        if (!$revoked) return;
        $this->audit->log(
            $actorUserId,
            AuditEvents::SESSION_REVOKED,
            $ip,
            $ua,
            null,
            null,
            ['by' => 'token_id', 'token_id' => $tokenId]
        );
    }

    public function logoutByRefreshCookie(
        ?string $refreshToken,
        ?string $ip,
        ?string $ua,
        ?int $actorUserId = null
    ): void {
        if($refreshToken === null) return;
        if($refreshToken === '') return;
        $revoked = $this->sessions->revokeByRefreshToken($refreshToken);
        if(!$revoked) return;
        $this->audit->log(
            $actorUserId,
            AuditEvents::SESSION_REVOKED,
            $ip,
            $ua,
            null,
            null,
            ['by' => 'refresh_token']
        );
        // $this->audit->log($actorUserId, 'logout.no_session', $ip, $ua);
    }
}

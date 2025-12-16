<?php
declare(strict_types=1);

final class SettingKeys
{
    // security/*
    public const SECURITY_MAX_FAILED_LOGINS        = 'security.max_failed_logins';
    public const SECURITY_FAILED_WINDOW_MINUTES    = 'security.failed_login_window_minutes';
    public const SECURITY_LOCKOUT_DURATION_MINUTES = 'security.lockout_duration_minutes';
    public const SECURITY_LOCKOUT_ESCALATION       = 'security.lockout_escalation_enabled';
    public const SECURITY_LOCKOUT_BY_IP            = 'security.lockout_by_ip_enabled';
    public const SECURITY_MAX_LOCKOUT_MINUTES      = 'security.max_lockout_duration_minutes';
    public const SECURITY_LOCKOUT_RECENT_HOURS     = 'security.lockout_recent_hours';
    public const SECURITY_LOCKOUT_ESCALATION_MAX   = 'security.lockout_escalation_max';
  
    // sessions/*
    public const SESSIONS_REFRESH_TTL_DAYS         = 'sessions.refresh_token_ttl_days';
    public const SESSIONS_MAX_PER_USER             = 'sessions.max_sessions_per_user';
    public const SESSIONS_ROTATE_REFRESH_TOKENS    = 'sessions.rotate_refresh_tokens';

    // auth/*
    public const AUTH_PASSWORD_REHASH_ON_LOGIN     = 'auth.password_rehash_on_login';
    public const AUTH_ARGON2_MEMORY_COST           = 'auth.argon2_memory_cost';
    public const AUTH_ARGON2_TIME_COST             = 'auth.argon2_time_cost';
    public const AUTH_ARGON2_THREADS               = 'auth.argon2_threads';

    // audit/*
    public const AUDIT_RETENTION_DAYS              = 'audit.audit_retention_days';
    public const AUDIT_ANONYMIZE_IP_AFTER_DAYS     = 'audit.anonymize_ip_after_days';

    // cookies/*
    public const COOKIES_REFRESH_SAMESITE          = 'cookies.refresh_samesite';
    public const COOKIES_REFRESH_PATH              = 'cookies.refresh_path';

    // mfa/*
    public const MFA_ALLOW_TOTP                    = 'mfa.allow_totp';
    public const MFA_CHALLENGE_TTL_MINUTES         = 'mfa.challenge_ttl_minutes';
    public const MFA_TOTP_PERIOD_SECONDS           = 'mfa.totp_period_seconds';
    public const MFA_TOTP_WINDOW                   = 'mfa.totp_window';
    public const MFA_TOTP_DIGITS                   = 'mfa.totp_digits';
    public const MFA_TOTP_SECRET_KEY               = 'mfa.totp_secret_key';

    // jwt /*
    public const JWT_SIGNING_ALGORITHM              = 'jwt.signing_algorithm';
    public const JWT_ISSUER                         = 'jwt.issuer';
    public const JWT_AUDIENCE                       = 'jwt.audience';
    public const JWT_ACCESS_TOKEN_TTL_SECONDS       = 'jwt.access_token_ttl_seconds';
    public const JWT_CLOCK_SKEW_SECONDS             = 'jwt.clock_skew_seconds';

    private function __construct() {}
}

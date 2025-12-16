<?php
declare(strict_types=1);

namespace Auth;

final class AuditEvents
{
    // Login
    public const LOGIN_SUCCESS      = 'login.success';
    public const LOGIN_FAILED       = 'login.failed';
    public const LOGIN_LOCKED       = 'login.locked';
    public const LOGIN_MFA_REQUIRED = 'login.mfa_required';

    // MFA
    public const MFA_TOTP_ENABLED   = 'mfa.totp.enabled';
    public const MFA_TOTP_DISABLED  = 'mfa.totp.disabled';
    public const MFA_SMS_ENABLED    = 'mfa.sms.enabled';
    public const MFA_SMS_DISABLED   = 'mfa.sms.disabled';
    public const MFA_CHALLENGE_SENT = 'mfa.challenge.sent';
    public const MFA_CHALLENGE_OK   = 'mfa.challenge.ok';
    public const MFA_CHALLENGE_FAIL = 'mfa.challenge.fail';

    // Sessions / tokens
    public const SESSION_CREATED    = 'session.created';
    public const SESSION_REFRESHED  = 'session.refreshed';
    public const SESSION_REVOKED    = 'session.revoked';

    // Accounts / security
    public const PASSWORD_RESET_REQUESTED = 'password_reset.requested';
    public const PASSWORD_RESET_USED      = 'password_reset.used';
    public const EMAIL_VERIFY_REQUESTED   = 'email_verify.requested';
    public const EMAIL_VERIFY_USED        = 'email_verify.used';

    // Admin / approvals / invites
    public const ACCOUNT_REQUESTED   = 'account.requested';
    public const ACCOUNT_APPROVED    = 'account.approved';
    public const ACCOUNT_DENIED      = 'account.denied';
    public const INVITE_SENT         = 'invite.sent';
    public const INVITE_ACCEPTED     = 'invite.accepted';

    private function __construct() {}
}

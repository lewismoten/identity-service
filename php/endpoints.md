Web UI endpoints users hit in a browser

Core auth

* GET /login – login form (username/email + password)
* POST /login – submit login
* POST /logout – end session
* GET /register – self-registration (if enabled)
* POST /register – submit registration
* GET /request-access – account request form (if requests enabled)
* POST /request-access – submit request
* GET /invite/accept?token=... – invitation acceptance page
* POST /invite/accept – finalize account creation from invite

Email verification & recovery

* GET /verify-email?token=... – verify email link landing
* POST /verify-email – confirm verification (optional)
* GET /forgot-password – request reset form
* POST /forgot-password – send reset email
* GET /reset-password?token=... – reset form
* POST /reset-password – submit new password

MFA (TOTP/SMS/passkeys)

* GET /mfa – MFA overview (manage methods)
* GET /mfa/challenge – MFA prompt after password login (“enter code / use passkey”)
* POST /mfa/verify – verify OTP/TOTP
* POST /mfa/recovery-code – verify a backup code

TOTP setup:

* GET /mfa/totp/setup – show QR + secret
* POST /mfa/totp/enable – confirm TOTP code and enable
* POST /mfa/totp/disable – disable TOTP (requires re-auth)

SMS setup:

* GET /mfa/sms/setup – add phone
* POST /mfa/sms/send – send verification code
* POST /mfa/sms/verify – verify phone code
* POST /mfa/sms/enable – enable SMS as MFA

Passkeys:

* GET /mfa/passkeys – manage passkeys
* POST /mfa/passkeys/register/options – begin WebAuthn registration
* POST /mfa/passkeys/register/verify – finish registration
* POST /mfa/passkeys/login/options – begin WebAuthn login
* POST /mfa/passkeys/login/verify – finish login
* POST /mfa/passkeys/revoke – remove passkey

Trusted devices:

* POST /mfa/trusted-devices/add – “remember this device”
* GET /mfa/trusted-devices – list
* POST /mfa/trusted-devices/revoke – revoke one/all

Account & security settings

* GET /account – profile overview
* GET /account/security – sessions, MFA, password, devices
* GET /account/sessions – list active sessions
* POST /account/sessions/revoke – revoke session(s)
* GET /account/api-keys – API keys UI
* POST /account/api-keys – create API key
* POST /account/api-keys/revoke – revoke key
* POST /account/api-keys/rotate – rotate key

Preferences / locale

* GET /account/preferences – locale, formatting, language
* POST /account/preferences – update preferences

Push notifications

* GET /account/notifications – notification settings
* POST /push/subscribe – register subscription
* POST /push/unsubscribe – revoke subscription

Admin / reviewer endpoints (still “users,” just privileged)
Review account requests

* GET /admin/onboarding/requests
* POST /admin/onboarding/requests/{id}/approve
* POST /admin/onboarding/requests/{id}/deny

Invites

* GET /admin/onboarding/invites
* POST /admin/onboarding/invites – create invite
* POST /admin/onboarding/invites/{id}/revoke

Roles / permissions

* GET /admin/rbac/users/{id} – view roles
* POST /admin/rbac/users/{id}/roles – grant/revoke roles
* GET /admin/rbac/roles
* POST /admin/rbac/roles
* GET /admin/rbac/permissions

System settings

* GET /admin/settings
* POST /admin/settings – update global
* POST /admin/settings/user-override – set per-user overrides (dev debug)

Message templates / localization

* GET /admin/templates
* POST /admin/templates
* GET /admin/i18n/messages
* POST /admin/i18n/messages

OIDC / OAuth2 SSO endpoints (apps will hit these, users will see the consent/login)

Authorization flow (Authorization Code + PKCE)

* GET /oauth/authorize – browser redirect from client app (login + consent happens here)
* POST /oauth/authorize – submit consent/deny (sometimes same endpoint)
* POST /oauth/token – client exchanges code for tokens

Token lifecycle

* POST /oauth/revoke – revoke refresh/access tokens
* POST /oauth/introspect – token introspection (optional)

OIDC discovery + keys

* GET /.well-known/openid-configuration
* GET /.well-known/jwks.json

OIDC user info + session

* GET /oauth/userinfo
* GET /oauth/logout (RP-initiated logout, optional)
* GET /oauth/session/check (optional)

Registration of clients (admin/dev)

* GET /admin/oidc/clients
* POST /admin/oidc/clients
* POST /admin/oidc/clients/{id}/rotate-secret
* POST /admin/oidc/clients/{id}/redirect-uris

JSON API endpoints (what your React app will call)

Auth/session

* POST /api/auth/login
* POST /api/auth/logout
* POST /api/auth/refresh (refresh token rotation)
* GET /api/auth/me (who am I; username/email/roles)
* GET /api/auth/sessions
* POST /api/auth/sessions/revoke

Registration/onboarding

* POST /api/onboarding/request
* GET /api/onboarding/request/status (optional)
* POST /api/onboarding/invite/accept
* POST /api/onboarding/invite/create (permission-guarded)
* POST /api/onboarding/invite/revoke (permission-guarded)
* GET /api/onboarding/requests (admin)
* POST /api/onboarding/requests/{id}/approve (admin)
* POST /api/onboarding/requests/{id}/deny (admin)

Email verification / password reset

* POST /api/recovery/password/request
* POST /api/recovery/password/confirm
* POST /api/recovery/email/verify/request (optional resend)
* POST /api/recovery/email/verify/confirm

MFA

* GET /api/mfa/methods
* POST /api/mfa/totp/setup
* POST /api/mfa/totp/enable
* POST /api/mfa/totp/disable
* POST /api/mfa/sms/add
* POST /api/mfa/sms/send
* POST /api/mfa/sms/verify
* POST /api/mfa/verify (generic verify endpoint: totp/sms/recovery)
* POST /api/mfa/backup-codes/regenerate

Passkeys (WebAuthn):

* POST /api/webauthn/register/options
* POST /api/webauthn/register/verify
* POST /api/webauthn/login/options
* POST /api/webauthn/login/verify
* POST /api/webauthn/credentials/revoke

Trusted devices:

* POST /api/trusted-devices/add
* GET /api/trusted-devices
* POST /api/trusted-devices/revoke

Preferences / locale

* GET /api/preferences
* POST /api/preferences

Push

* POST /api/push/subscribe
* POST /api/push/unsubscribe
* GET /api/push/preferences
* POST /api/push/preferences

API keys

* GET /api/api-keys
* POST /api/api-keys
* POST /api/api-keys/revoke
* POST /api/api-keys/rotate
* GET /api/api-scopes (for UI selection)

Admin-only system & i18n

* GET /api/admin/settings
* POST /api/admin/settings
* POST /api/admin/settings/user-override
* GET /api/admin/i18n/messages
* POST /api/admin/i18n/messages
* GET /api/admin/rbac/users/{id}/roles
* POST /api/admin/rbac/users/{id}/roless
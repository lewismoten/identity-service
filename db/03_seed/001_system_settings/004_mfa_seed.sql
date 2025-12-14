INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
-- Core MFA behavior
('mfa', 'allow_multiple_mfa_methods', '1', 'Allow users to register multiple MFA methods', 0, 0, 'boolean'),
('mfa', 'require_primary_mfa', '1', 'Require one MFA method to be marked as primary', 0, 0, 'boolean'),
('mfa', 'require_mfa_for_login', '0', 'Require MFA for all logins', 0, 0, 'boolean'),
('mfa', 'require_mfa_for_sensitive_actions', '1', 'Require MFA for sensitive account actions', 0, 0, 'boolean'),

-- Method availability
('mfa', 'allow_totp', '1', 'Allow TOTP-based MFA', 0, 0, 'boolean'),
('mfa', 'allow_sms', '1', 'Allow SMS-based MFA', 0, 0, 'boolean'),
('mfa', 'allow_webauthn', '0', 'Allow WebAuthn / passkeys', 0, 0, 'boolean'),

-- Fallback behavior
('mfa', 'allow_sms_fallback', '1', 'Allow SMS as fallback MFA method', 0, 0, 'boolean'),
('mfa', 'allow_recovery_codes', '1', 'Allow MFA recovery codes', 0, 0, 'boolean'),

-- Enforcement
('mfa', 'invalidate_sessions_on_mfa_change', '1', 'Invalidate sessions when MFA configuration changes', 0, 0, 'boolean'),
('mfa', 'invalidate_sessions_on_primary_change', '1', 'Invalidate sessions when primary MFA method changes', 0, 0, 'boolean')


/*
('mfa','allow_totp','1','Enable TOTP multi-factor authentication',0,0,'boolean'),
('mfa','totp_issuer_name','ExampleApp','Issuer name shown in authenticator apps',0,1,'string'),
('mfa','totp_digits','6','Number of digits for TOTP codes',0,0,'int'),
('mfa','totp_period_seconds','30','TOTP time step in seconds',0,0,'int'),
('mfa','totp_window','1','Allowed TOTP drift window',0,0,'int'),
('mfa','totp_window','1','Allowed TOTP drift window',0,0,'int'),
('mfa','require_mfa_for_login','0','Require MFA for all users',0,0,'boolean'),
('mfa','require_mfa_for_admins','1','Require MFA for privileged users',0,0,'boolean'),
('mfa','backup_codes_count','10','Number of MFA recovery codes',0,0,'int'),
('mfa','invalidate_sessions_on_mfa_enable','1','Invalidate sessions when MFA is enabled',0,0,'boolean')
*/
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

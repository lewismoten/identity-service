INSERT INTO system_settings
(category, name, value, description, can_delete, can_rename, format)
VALUES
('mfa_method', 'totp', '1', 'Time-based one-time password (authenticator app)', 0, 0, 'boolean'),
('mfa_method', 'sms', '0', 'SMS one-time passcode (weak)', 0, 0, 'boolean'),
('mfa_method', 'webauthn', '0', 'WebAuthn / passkeys', 0, 0, 'boolean'),
('mfa_method', 'email_otp', '0', 'Email-based OTP (discouraged)', 0, 0, 'boolean')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

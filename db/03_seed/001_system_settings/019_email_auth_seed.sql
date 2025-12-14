INSERT INTO system_settings
(category, name, value, description, can_delete, can_rename, format)
VALUES
('email_auth', 'allow_email_otp', '1', 'Allow email-based OTP authentication', 0, 0, 'boolean'),
('email_auth', 'email_otp_length', '6', 'Length of email OTP codes', 0, 0, 'int'),
('email_auth', 'email_otp_ttl_seconds', '600', 'Email OTP lifetime in seconds', 0, 0, 'int'),
('email_auth', 'max_email_otp_attempts', '5', 'Max attempts per email OTP challenge', 0, 0, 'int'),
('email_auth', 'allow_email_passwordless', '0', 'Allow passwordless login via email OTP', 0, 0, 'boolean'),
('email_auth', 'email_otp_rate_limit_per_hour', '10', 'Rate limit for email OTP sends', 0, 0, 'int')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

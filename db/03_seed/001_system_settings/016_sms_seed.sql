INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('sms', 'enabled', '0', 'Enable SMS sending (MFA/verification)', 0, 0, 'boolean'),
('sms', 'provider', '', 'SMS provider (twilio/etc)', 0, 0, 'string'),
('sms', 'from_number', '', 'Default sending number (E.164)', 0, 0, 'string'),

('sms', 'otp_length', '6', 'Length of SMS OTP codes', 0, 0, 'int'),
('sms', 'otp_ttl_seconds', '300', 'SMS OTP lifetime in seconds', 0, 0, 'int'),
('sms', 'max_attempts_per_challenge', '5', 'Max code entry attempts per OTP challenge', 0, 0, 'int'),

('sms', 'max_sends_per_hour_per_phone', '5', 'Rate limit: SMS sends per phone per hour', 0, 0, 'int'),
('sms', 'max_sends_per_hour_per_ip', '20', 'Rate limit: SMS sends per IP per hour', 0, 0, 'int'),
('sms', 'max_sends_per_hour_per_user', '10', 'Rate limit: SMS sends per user per hour', 0, 0, 'int'),
('sms', 'cooldown_seconds', '30', 'Minimum seconds between OTP sends', 0, 0, 'int'),

('sms', 'require_verified_phone_for_sms_mfa', '1', 'Require phone number verification before SMS MFA', 0, 0, 'boolean'),
('sms', 'allow_sms_as_primary_mfa', '0', 'Allow SMS as primary MFA (not recommended)', 0, 0, 'boolean'),
('sms', 'allow_sms_for_recovery', '1', 'Allow SMS for account recovery flows', 0, 0, 'boolean'),

('sms', 'log_sms_events', '1', 'Write SMS send/verify events to audit log', 0, 0, 'boolean'),
('sms', 'sms_mfa_priority', '2', 'Priority order for SMS MFA (lower = higher priority)', 0, 0, 'int'),
('sms', 'sms_mfa_max_active_methods', '3', 'Maximum SMS MFA methods per user', 0, 0, 'int')


ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

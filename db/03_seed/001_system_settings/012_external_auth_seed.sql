INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('external_auth', 'enable_external_login', '1', 'Enable external identity providers', 0, 0, 'boolean'),
('external_auth', 'enable_google_login', '1', 'Enable Google login', 0, 0, 'boolean'),
('external_auth', 'enable_facebook_login', '1', 'Enable Facebook login', 0, 0, 'boolean'),

('external_auth', 'external_state_ttl_seconds', '600', 'TTL for external OAuth state values', 0, 0, 'int'),
('external_auth', 'external_linking_allowed', '1', 'Allow linking external identity to existing account', 0, 0, 'boolean'),
('external_auth', 'external_auto_create_user', '1', 'Automatically create user on first external login', 0, 0, 'boolean'),

('external_auth', 'require_verified_email_for_link', '1', 'Require provider-verified email before linking accounts', 0, 0, 'boolean'),
('external_auth', 'log_external_auth_events', '1', 'Audit external login and linking events', 0, 0, 'boolean')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);
INSERT INTO system_settings
(category, name, value, description, can_delete, can_rename, format)
VALUES
-- Master switch
('api_keys', 'enabled', '1', 'Enable user-issued API keys', 0, 0, 'boolean'),

-- Limits
('api_keys', 'max_apps_per_user', '10', 'Maximum number of API apps per user', 0, 0, 'int'),
('api_keys', 'max_keys_per_app', '5', 'Maximum API keys per app', 0, 0, 'int'),
('api_keys', 'max_keys_per_user', '20', 'Maximum active API keys per user', 0, 0, 'int'),

-- Expiration policy
('api_keys', 'default_key_ttl_days', '90', 'Default API key expiration (days); NULL = never', 0, 0, 'int'),
('api_keys', 'default_expiry_days', '365', 'Default API key expiry in days (NULL/0 for no expiry)', 0, 0, 'int'),
('api_keys', 'allow_non_expiring_keys', '1', 'Allow API keys without expiration', 0, 0, 'boolean'),
('api_keys', 'max_key_ttl_days', '365', 'Maximum allowed API key lifetime', 0, 0, 'int'),

-- Security behavior
('api_keys', 'hash_algorithm', 'hmac_sha256', 'Hash algorithm for API keys', 0, 0, 'string'),
('api_keys', 'require_prefix', '1', 'Require public prefix on API keys', 0, 0, 'boolean'),
('api_keys', 'key_prefix_length', '8', 'Length of public API key prefix', 0, 0, 'int'),

-- Rotation & revocation
('api_keys', 'allow_key_rotation', '1', 'Allow rotating API keys', 0, 0, 'boolean'),
('api_keys', 'revoke_old_key_on_rotation', '1', 'Revoke old key when rotated', 0, 0, 'boolean'),
('api_keys', 'rotate_requires_new_key', '1', 'Rotation creates a new key and revokes the old', 0, 0, 'boolean'),

-- Auditing & logging
('api_keys', 'log_auth_success', '0', 'Log successful API key authentications', 0, 0, 'boolean'),
('api_keys', 'log_auth_failure', '1', 'Log failed API key authentications', 0, 0, 'boolean'),
('api_keys', 'require_label', '1', 'Require a label when creating an API key', 0, 0, 'boolean'),

-- Rate limiting (coarse, per key)
('api_keys', 'rate_limit_requests_per_minute', '600', 'Requests per minute per API key', 0, 0, 'int'),
('api_keys', 'rate_limit_burst', '100', 'Burst size for API key rate limiting', 0, 0, 'int')


ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

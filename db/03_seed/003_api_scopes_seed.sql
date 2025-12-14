INSERT INTO api_scopes (scope, description, is_active)
VALUES
('profile:read',  'Read basic user profile information', 1),
('profile:write', 'Modify user profile information', 1),

('identity:read', 'Read identity and authentication metadata', 1),
('identity:write', 'Modify identity-related settings', 0),

('sessions:read', 'Read active sessions for the account', 1),
('sessions:revoke', 'Revoke active sessions', 1),

('mfa:read', 'Read MFA configuration status', 1),
('mfa:write', 'Modify MFA configuration', 0),

('api_keys:read', 'List API keys and metadata', 1),
('api_keys:write', 'Create, rotate, or revoke API keys', 1),

('audit:read', 'Read audit log entries', 0),

('admin:full', 'Full administrative access (dangerous)', 0)

ON DUPLICATE KEY UPDATE
  description = VALUES(description),
  is_active = VALUES(is_active);

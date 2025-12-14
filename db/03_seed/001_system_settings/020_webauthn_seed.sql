INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('webauthn', 'enabled', '1', 'Enable WebAuthn / passkeys', 0, 0, 'boolean'),

('webauthn', 'rp_id', 'identity.example.com', 'WebAuthn Relying Party ID (domain, no scheme)', 0, 0, 'string'),
('webauthn', 'rp_name', 'YourSite Identity', 'WebAuthn Relying Party display name', 0, 0, 'string'),
('webauthn', 'origin', 'https://identity.regaldragondanceparty.com', 'Allowed WebAuthn origin', 0, 0, 'url'),

('webauthn', 'challenge_ttl_seconds', '300', 'Challenge lifetime in seconds', 0, 0, 'int'),

('webauthn', 'require_user_verification', '1', 'Require user verification (biometric/PIN) when available', 0, 0, 'boolean'),
('webauthn', 'require_resident_key', '0', 'Require discoverable (resident) credentials', 0, 0, 'boolean'),

('webauthn', 'attestation', 'none', 'Attestation conveyance preference (none/direct/indirect/enterprise)', 0, 0, 'string'),

('webauthn', 'algorithms', 'ES256,RS256', 'Allowed COSE algorithms', 0, 0, 'string'),

('webauthn', 'allow_multiple_credentials', '1', 'Allow multiple passkeys per user', 0, 0, 'boolean'),
('webauthn', 'log_events', '1', 'Audit passkey register/login events', 0, 0, 'boolean')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('oidc', 'issuer', 'https://identity.example.com', 'OIDC issuer (must exactly match issuer in discovery/JWKS and tokens)', 0, 1, 'string'),
('oidc', 'authorization_code_ttl_seconds', '120', 'Authorization code lifetime (seconds)', 0, 0, 'int'),
('oidc', 'id_token_ttl_seconds', '600', 'ID token lifetime (seconds)', 0, 0, 'int'),
('oidc', 'require_nonce', '1', 'Require nonce parameter for OIDC authentication requests', 0, 0, 'boolean'),
('oidc', 'allow_implicit_flow', '0', 'Allow implicit flow (recommended off)', 0, 0, 'boolean'),
('oidc', 'allow_hybrid_flow', '0', 'Allow hybrid flow (recommended off)', 0, 0, 'boolean'),
('oidc', 'supported_id_token_algs', 'RS256', 'Comma-separated supported ID token algs', 0, 0, 'string'),
('oidc', 'userinfo_enabled', '1', 'Enable /userinfo endpoint', 0, 0, 'boolean'),
('oidc', 'consent_required', '0', 'Require consent screen for first-party clients', 0, 0, 'boolean'),
('oidc', 'require_pkce_for_public_clients', '1', 'Require PKCE for public clients', 0, 0, 'boolean')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('google_oauth', 'client_id', '', 'Google OAuth client ID', 0, 0, 'string'),
('google_oauth', 'client_secret', '', 'Google OAuth client secret', 0, 0, 'secret'),
('google_oauth', 'redirect_uri', 'https://identity.regaldragondanceparty.com/oauth/google/callback', 'Google OAuth redirect URI', 0, 0, 'url'),
('google_oauth', 'scopes', 'openid profile email', 'Requested Google OAuth scopes', 0, 0, 'string'),

('google_oauth', 'use_pkce', '1', 'Use PKCE with Google OAuth', 0, 0, 'boolean'),
('google_oauth', 'prompt', 'select_account', 'OAuth prompt behavior', 1, 1, 'string'),
('google_oauth', 'access_type', 'online', 'OAuth access type (online/offline)', 1, 1, 'string')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

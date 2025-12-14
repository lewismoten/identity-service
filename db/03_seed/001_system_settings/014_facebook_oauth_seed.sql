INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('facebook_oauth', 'client_id', '', 'Facebook OAuth app ID', 0, 0, 'string'),
('facebook_oauth', 'client_secret', '', 'Facebook OAuth app secret', 0, 0, 'secret'),
('facebook_oauth', 'redirect_uri', 'https://identity.regaldragondanceparty.com/oauth/facebook/callback', 'Facebook OAuth redirect URI', 0, 0, 'url'),
('facebook_oauth', 'scopes', 'email public_profile', 'Requested Facebook OAuth scopes', 0, 0, 'string'),

('facebook_oauth', 'use_pkce', '1', 'Use PKCE with Facebook OAuth', 0, 0, 'boolean'),
('facebook_oauth', 'auth_type', 'rerequest', 'OAuth auth_type parameter', 1, 1, 'string')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

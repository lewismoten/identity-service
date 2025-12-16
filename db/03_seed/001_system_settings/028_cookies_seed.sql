INSERT INTO system_settings (
  category, name, value, description, can_delete, can_rename, format
) VALUES
('cookies', 'refresh_samesite', 'Lax', 'SameSite attribute for refresh_token cookie (Lax or None)', 0, 0, 'string'),
('cookies', 'refresh_path', '/api/auth', 'Path for refresh_token cookie', 0, 0, 'string')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

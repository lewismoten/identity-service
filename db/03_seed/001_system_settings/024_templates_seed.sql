INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('templates', 'default_language', 'en-US', 'Default language for templates', 0, 0, 'string'),
('templates', 'fallback_language', 'en', 'Fallback language if specific locale is missing', 0, 0, 'string'),
('templates', 'default_variant', 'default', 'Default template variant', 0, 0, 'string'),
('templates', 'sms_max_length', '160', 'Soft limit for SMS template length', 0, 0, 'int')

ON DUPLICATE KEY UPDATE
  value=VALUES(value),
  description=VALUES(description),
  can_delete=VALUES(can_delete),
  can_rename=VALUES(can_rename),
  format=VALUES(format);

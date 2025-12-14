INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('login_alert', 'push', 'en-US', 'default',
 NULL,
 'New sign-in to {{app_name}}. If this wasn’t you, secure your account.',
 'text',
 '["{{app_name}}"]',
 'Web push login alert (body)',
 1, 1)

ON DUPLICATE KEY UPDATE
  subject = VALUES(subject),
  body = VALUES(body),
  format = VALUES(format),
  variables_json = VALUES(variables_json),
  description = VALUES(description),
  is_active = VALUES(is_active),
  version = VALUES(version),
  updated_at = CURRENT_TIMESTAMP;

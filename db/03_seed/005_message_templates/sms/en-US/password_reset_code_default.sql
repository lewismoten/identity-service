INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('password_reset_code', 'sms', 'en-US', 'default',
 NULL,
 '{{app_name}} password reset code: {{code}}. Expires in {{ttl_minutes}} min.',
 'text',
 '["{{app_name}}","{{code}}","{{ttl_minutes}}"]',
 'SMS password reset code',
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

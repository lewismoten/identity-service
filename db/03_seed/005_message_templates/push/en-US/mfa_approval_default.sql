INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('mfa_approval', 'push', 'en-US', 'default',
 NULL,
 'Approve sign-in to {{app_name}}? Open to confirm.',
 'text',
 '["{{app_name}}"]',
 'Web push prompt to approve sign-in (body)',
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

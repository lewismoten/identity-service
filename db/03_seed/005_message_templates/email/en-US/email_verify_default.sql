INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('email_verify', 'email', 'en-US', 'default',
 'Verify your email for {{app_name}}',
 '<p>Hi{{#if username}} {{username}}{{/if}},</p>
  <p>Please verify your email address by clicking the link below:</p>
  <p><a href="{{verify_url}}">Verify email</a></p>
  <p>This link expires in {{ttl_minutes}} minutes.</p>
  <p>If you did not request this, you can ignore this email.</p>',
 'html',
 '["{{app_name}}","{{username}}","{{verify_url}}","{{ttl_minutes}}"]',
 'Email verification message',
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

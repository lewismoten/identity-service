INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('password_reset', 'email', 'en-US', 'default',
 'Reset your password for {{app_name}}',
 '<p>Hi{{#if username}} {{username}}{{/if}},</p>
  <p>We received a request to reset your password.</p>
  <p><a href="{{reset_url}}">Reset password</a></p>
  <p>This link expires in {{ttl_minutes}} minutes.</p>
  <p>If you didn’t request this, please ignore this message.</p>',
 'html',
 '["{{app_name}}","{{username}}","{{reset_url}}","{{ttl_minutes}}"]',
 'Password reset email',
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

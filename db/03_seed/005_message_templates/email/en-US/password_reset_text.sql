INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('password_reset', 'email', 'en-US', 'text',
 'Reset your password for {{app_name}}',
 'Hi{{#if username}} {{username}}{{/if}},

We received a request to reset your password.
Reset it here:
{{reset_url}}

This link expires in {{ttl_minutes}} minutes.
If you didn’t request this, ignore this message.',
 'text',
 '["{{app_name}}","{{username}}","{{reset_url}}","{{ttl_minutes}}"]',
 'Password reset (plain text)',
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

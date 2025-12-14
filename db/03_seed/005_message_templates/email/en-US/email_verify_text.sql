INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('email_verify', 'email', 'en-US', 'text',
 'Verify your email for {{app_name}}',
 'Hi{{#if username}} {{username}}{{/if}},

Please verify your email address using this link:
{{verify_url}}

This link expires in {{ttl_minutes}} minutes.
If you did not request this, you can ignore this email.',
 'text',
 '["{{app_name}}","{{username}}","{{verify_url}}","{{ttl_minutes}}"]',
 'Email verification (plain text)',
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

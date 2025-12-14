INSERT INTO message_templates
(action_key, channel, language_tag, variant, subject, body, format, variables_json, description, is_active, version)
VALUES

('login_alert', 'email', 'en-US', 'default',
 'New sign-in to your {{app_name}} account',
 '<p>Hi{{#if username}} {{username}}{{/if}},</p>
  <p>We noticed a new sign-in to your account.</p>
  <ul>
    <li>Time: {{event_time}}</li>
    <li>IP: {{ip_address}}</li>
    <li>Device: {{user_agent}}</li>
  </ul>
  <p>If this was you, no action is needed.</p>
  <p>If not, please reset your password and review active sessions.</p>
  <p><a href="{{security_url}}">Review security</a></p>',
 'html',
 '["{{app_name}}","{{username}}","{{event_time}}","{{ip_address}}","{{user_agent}}","{{security_url}}"]',
 'Login alert email',
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

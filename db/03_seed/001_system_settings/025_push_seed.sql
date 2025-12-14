INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('push', 'enabled', '1', 'Enable web push notifications', 0, 0, 'boolean'),

-- VAPID configuration (store private key outside DB if possible)
('push', 'vapid_subject', 'mailto:admin@regaldragondanceparty.com', 'VAPID subject (mailto: or URL)', 0, 0, 'string'),
('push', 'vapid_public_key', '', 'VAPID public key (base64url)', 0, 0, 'string'),
('push', 'vapid_private_key', '', 'VAPID private key (base64url) - prefer config/env over DB', 0, 0, 'secret'),

-- Defaults
('push', 'default_title', '{{app_name}}', 'Default push notification title', 0, 0, 'string'),
('push', 'default_ttl_seconds', '300', 'Default push TTL in seconds', 0, 0, 'int'),
('push', 'default_urgency', 'normal', 'Default urgency: very-low/low/normal/high', 0, 0, 'string'),
('push', 'default_click_url', 'https://identity.regaldragondanceparty.com/account/security', 'Default click-through URL', 0, 0, 'url'),

-- Subscription hygiene
('push', 'subscription_max_per_user', '10', 'Maximum active subscriptions per user', 0, 0, 'int'),
('push', 'prune_revoked_after_days', '30', 'Days after which revoked subscriptions may be deleted', 0, 0, 'int'),

-- Rate limiting / abuse controls
('push', 'max_sends_per_user_per_hour', '30', 'Rate limit: pushes per user per hour', 0, 0, 'int'),
('push', 'max_sends_per_ip_per_hour', '60', 'Rate limit: subscription/register events per IP per hour', 0, 0, 'int'),

-- Logging
('push', 'log_push_events', '1', 'Log push delivery events to push_delivery_log', 0, 0, 'boolean')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

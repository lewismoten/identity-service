CREATE TABLE IF NOT EXISTS message_templates (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  action_key VARCHAR(64) NOT NULL,
  `channel` VARCHAR(16) NOT NULL,
  language_tag VARCHAR(16) NOT NULL,
  variant VARCHAR(32) NOT NULL DEFAULT 'default',
  subject VARCHAR(255) NULL,
  body TEXT NOT NULL,
  format VARCHAR(16) NOT NULL DEFAULT 'text',
  variables_json JSON NULL,
  description VARCHAR(255) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_template (action_key, channel, language_tag, variant, version),
  KEY idx_templates_lookup (action_key, channel, language_tag, variant, is_active),
  KEY idx_templates_action_channel (action_key, channel),
  KEY idx_templates_language (language_tag),
  KEY idx_templates_active (is_active),
  CONSTRAINT chk_message_templates_channel
    CHECK (`channel` IN ('email','sms','push'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

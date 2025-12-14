CREATE TABLE IF NOT EXISTS i18n_messages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  message_key VARCHAR(128) NOT NULL,
  locale_tag VARCHAR(16) NOT NULL,
  message_text TEXT NOT NULL,
  message_help TEXT NULL,
  category VARCHAR(64) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uq_i18n_key_locale (message_key, locale_tag),
  KEY idx_i18n_locale_active (locale_tag, is_active),
  KEY idx_i18n_key_active (message_key, is_active),
  KEY idx_i18n_category (category)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

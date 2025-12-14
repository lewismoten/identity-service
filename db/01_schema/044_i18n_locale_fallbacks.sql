CREATE TABLE IF NOT EXISTS i18n_locale_fallbacks (
  locale_tag VARCHAR(16) NOT NULL PRIMARY KEY,
  fallback_locale_tag VARCHAR(16) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_i18n_fallback (fallback_locale_tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

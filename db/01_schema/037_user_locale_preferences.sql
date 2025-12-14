CREATE TABLE IF NOT EXISTS user_locale_preferences (
  user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,

  language_primary VARCHAR(16) NOT NULL DEFAULT 'en-US',
  language_backup  VARCHAR(16) NULL,

  locale_primary VARCHAR(16) NOT NULL DEFAULT 'en-US',
  locale_backup  VARCHAR(16) NULL,

  week_start_day TINYINT UNSIGNED NOT NULL DEFAULT 7,

  date_format VARCHAR(32) NOT NULL DEFAULT 'YYYY-MM-DD',
  time_format VARCHAR(8) NOT NULL DEFAULT '24h',
  time_zone VARCHAR(64) NOT NULL DEFAULT 'UTC',   -- IANA TZ like 'America/New_York'
  number_decimal_sep CHAR(1) NOT NULL DEFAULT '.',
  number_group_sep   CHAR(1) NOT NULL DEFAULT ',',
  number_grouping VARCHAR(16) NOT NULL DEFAULT '3', 

  currency_primary CHAR(12) NOT NULL DEFAULT 'USD',
  currency_backup  CHAR(12) NULL,
  currency_display VARCHAR(16) NOT NULL DEFAULT 'symbol', 

  currency_crypto_unit VARCHAR(16) NULL, 

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_user_locale_prefs_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_prefs_currency_primary
    FOREIGN KEY (currency_primary) REFERENCES currencies(code)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_prefs_currency_backup
    FOREIGN KEY (currency_backup) REFERENCES currencies(code)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_prefs_language_primary
    FOREIGN KEY (language_primary) REFERENCES languages(tag)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_prefs_language_backup
    FOREIGN KEY (language_backup) REFERENCES languages(tag)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_prefs_locale_primary
    FOREIGN KEY (locale_primary) REFERENCES languages(tag)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_prefs_locale_backup
    FOREIGN KEY (locale_backup) REFERENCES languages(tag)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_week_start_day
    CHECK (week_start_day BETWEEN 1 AND 7),

  CONSTRAINT chk_time_format
    CHECK (time_format IN ('12h','24h')),

  CONSTRAINT chk_currency_display
    CHECK (currency_display IN ('symbol','code','name'))

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

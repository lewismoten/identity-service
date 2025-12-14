INSERT INTO system_settings
(category, name, value, description, can_delete, can_rename, format)
VALUES
-- Defaults applied when creating a new user (or when prefs row is missing)
('locale', 'default_language_primary', 'en-US', 'Default primary language (BCP-47)', 0, 0, 'string'),
('locale', 'default_language_backup', 'en', 'Default backup language (BCP-47)', 0, 0, 'string'),
('locale', 'default_locale_primary', 'en-US', 'Default primary locale (BCP-47)', 0, 0, 'string'),
('locale', 'default_locale_backup', 'en', 'Default backup locale (BCP-47)', 0, 0, 'string'),
('locale', 'default_time_zone', 'UTC', 'Default IANA time zone', 0, 0, 'string'),

-- Week/date/time defaults
('locale', 'default_week_start_day', '7', 'Default week start day (1=Mon..7=Sun)', 0, 0, 'int'),
('locale', 'default_date_format', 'YYYY-MM-DD', 'Default date format token pattern', 0, 0, 'string'),
('locale', 'default_time_format', '24h', 'Default time format (12h/24h)', 0, 0, 'string'),

-- Number formatting defaults (overrides; most UIs can ignore and use Intl)
('locale', 'default_number_decimal_sep', '.', 'Default decimal separator', 0, 0, 'string'),
('locale', 'default_number_group_sep', ',', 'Default thousands/group separator', 0, 0, 'string'),
('locale', 'default_number_grouping', '3', 'Default grouping rule (e.g., 3 or 3;2)', 0, 0, 'string'),

-- Currency defaults
('locale', 'default_currency_primary', 'USD', 'Default primary currency code', 0, 0, 'string'),
('locale', 'default_currency_backup', 'BTC', 'Default backup currency code', 0, 0, 'string'),
('locale', 'default_currency_display', 'symbol', 'Default currency display (symbol/code/name)', 0, 0, 'string'),
('locale', 'default_currency_crypto_unit', 'BTC', 'Default crypto unit (BTC/mBTC/sats)', 0, 0, 'string'),

-- Policy / safety rails
('locale', 'allow_user_override_number_format', '1', 'Allow users to override separators/grouping', 0, 0, 'boolean'),
('locale', 'allow_user_override_date_format', '1', 'Allow users to override date format tokens', 0, 0, 'boolean'),
('locale', 'allow_user_override_currency', '1', 'Allow users to choose currency preferences', 0, 0, 'boolean'),

-- Optional: constrain to a known set if you want (CSV list)
('locale', 'allowed_languages', 'en-US,en,es,fr,de', 'Comma-separated allowed language tags (empty = allow any valid tag)', 1, 1, 'string'),
('locale', 'allowed_locales', 'en-US,en,es,fr,de', 'Comma-separated allowed locale tags (empty = allow any valid tag)', 1, 1, 'string'),
('locale', 'allowed_currencies', 'USD,EUR,GBP,JPY,BTC,SAT', 'Comma-separated allowed currency codes (empty = allow any)', 1, 1, 'string'),

-- Fallback
('locale', 'fallback_to_default_on_invalid', '1', 'If user preference is invalid, fall back to defaults', 0, 0, 'boolean'),
('locale', 'fallback_to_backup_language', '1', 'Use backup language when primary not available', 0, 0, 'boolean'),
('locale', 'fallback_to_backup_currency', '1', 'Use backup currency when primary not available', 0, 0, 'boolean')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

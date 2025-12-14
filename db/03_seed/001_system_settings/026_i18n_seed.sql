INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('i18n', 'enabled', '1', 'Enable database-backed localization messages', 0, 0, 'boolean'),

-- Defaults if user has no prefs
('i18n', 'default_locale', 'en-US', 'Default locale if user preference is missing', 0, 0, 'string'),
('i18n', 'fallback_locale', 'en', 'Fallback locale if specific locale is missing', 0, 0, 'string'),

-- Behavior controls
('i18n', 'allow_locale_truncation_fallback', '1', 'Fallback from xx-YY to xx automatically', 0, 0, 'boolean'),
('i18n', 'missing_key_behavior', 'key', 'Behavior for missing keys: key/empty/error', 0, 0, 'string'),

-- Optional: constrain which locales you support in the product
('i18n', 'allowed_locales', 'en-US,en,es,fr,de', 'Comma-separated allowed locales (empty = allow any)', 1, 1, 'string'),

-- Performance options
('i18n', 'cache_ttl_seconds', '300', 'Recommended cache TTL for i18n lookups', 0, 0, 'int'),

-- Dev Locales
('i18n', 'dev_locales', 'x-dev,en-XA', 'Locales allowed only in development/admin contexts', 0, 0, 'string'),
('i18n', 'allow_dev_locale_for_users', '0', 'Allow end users to select dev locales', 0, 0, 'boolean'),
('i18n', 'debug_show_keys', '0', 'If enabled, return the message_key instead of a localized string', 0, 0, 'boolean'),
('i18n', 'debug_key_wrapper', '⟦{key}⟧', 'Wrapper format for debug keys. Use {key} placeholder', 0, 0, 'string'),
('i18n', 'debug_show_keys_for_non_admins', '0', 'Allow non-admin users to use debug_show_keys', 0, 0, 'boolean'),
('i18n', 'debug_append_resolved_locale', '0', 'Append the resolved locale used for the message lookup', 0, 0, 'boolean'),
('i18n', 'debug_locale_separator', '|', 'Separator between key and locale when debug_append_resolved_locale is enabled', 0, 0, 'string'),
('i18n', 'debug_key_locale_wrapper', '⟦{key}{sep}{locale}⟧', 'Wrapper for debug key+locale. Placeholders: {key}, {sep}, {locale}', 0, 0, 'string')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

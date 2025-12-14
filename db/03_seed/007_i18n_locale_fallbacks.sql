INSERT INTO i18n_locale_fallbacks (locale_tag, fallback_locale_tag) VALUES
-- Development
('x-dev', 'en-US'),
('en-XA', 'en-US'),

-- English
('en-US', 'en'),
('en-GB', 'en'),
('en',    'en-US'),

-- Spanish
('es-ES', 'es'),
('es-MX', 'es'),
('es-419','es'),
('es',    'en-US'),

-- French
('fr-FR', 'fr'),
('fr-CA', 'fr'),
('fr',    'en-US'),

-- German
('de-DE', 'de'),
('de-AT', 'de'),
('de',    'en-US'),

-- Portuguese (optional)
('pt-BR', 'pt'),
('pt-PT', 'pt'),
('pt',    'en-US'),

-- Italian (optional)
('it-IT', 'it'),
('it',    'en-US'),

-- Dutch (optional)
('nl-NL', 'nl'),
('nl',    'en-US'),

-- Japanese
('ja-JP', 'ja'),
('ja',    'en-US'),

-- Korean
('ko-KR', 'ko'),
('ko',    'en-US'),

-- Chinese
('zh-CN',   'zh-Hans'),
('zh-SG',   'zh-Hans'),
('zh-Hans', 'zh'),
('zh-TW',   'zh-Hant'),
('zh-HK',   'zh-Hant'),
('zh-Hant', 'zh'),
('zh',      'en-US')

ON DUPLICATE KEY UPDATE
  fallback_locale_tag = VALUES(fallback_locale_tag);

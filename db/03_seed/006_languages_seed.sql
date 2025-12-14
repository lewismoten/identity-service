INSERT INTO languages (tag, name, is_active) VALUES
('x-dev', 'Developer (terse)', 1),
('en-XA', 'English (Pseudo)', 1),

-- English
('en',    'English', 1),
('en-US', 'English (United States)', 1),
('en-GB', 'English (United Kingdom)', 1),

-- Spanish
('es',    'Español', 1),
('es-ES', 'Español (España)', 1),
('es-MX', 'Español (México)', 1),
('es-419','Español (Latinoamérica)', 1),

-- French
('fr',    'Français', 1),
('fr-FR', 'Français (France)', 1),
('fr-CA', 'Français (Canada)', 1),

-- German
('de',    'Deutsch', 1),
('de-DE', 'Deutsch (Deutschland)', 1),
('de-AT', 'Deutsch (Österreich)', 1),

-- Portuguese
('pt',    'Português', 1),
('pt-BR', 'Português (Brasil)', 1),
('pt-PT', 'Português (Portugal)', 1),

-- Italian
('it',    'Italiano', 1),
('it-IT', 'Italiano (Italia)', 1),

-- Dutch
('nl',    'Nederlands', 1),
('nl-NL', 'Nederlands (Nederland)', 1),

-- Japanese
('ja',    '日本語', 1),
('ja-JP', '日本語 (日本)', 1),

-- Korean
('ko',    '한국어', 1),
('ko-KR', '한국어 (대한민국)', 1),

-- Chinese (Simplified / Traditional)
('zh',       '中文', 1),
('zh-Hans',  '中文（简体）', 1),
('zh-Hant',  '中文（繁體）', 1),
('zh-CN',    '中文（简体，中国）', 1),
('zh-TW',    '中文（繁體，台灣）', 1),
('zh-HK',    '中文（繁體，香港）', 1)

ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  is_active = VALUES(is_active);

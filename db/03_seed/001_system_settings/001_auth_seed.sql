INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('auth','allow_registration','1','Enable public user registration',0,0,'boolean'),
('auth','require_email_verification','1','Require email verification before login',0,0,'boolean'),
('auth','username_min_length','3','Minimum username length',0,0,'int'),
('auth','username_max_length','32','Maximum username length',0,0,'int'),
('auth','password_min_length','12','Minimum password length',0,0,'int'),
('auth','password_require_complexity','1','Require complex passwords',0,0,'boolean'),
('auth','password_hash_algo','argon2id','Password hashing algorithm',0,0,'string'),
('auth','password_rehash_on_login','1','Upgrade password hashes on login',0,0,'boolean'),
('auth', 'argon2_memory_cost', '65536', 'Argon2id memory cost (KiB)', 0, 0, 'int'),
('auth', 'argon2_time_cost', '3', 'Argon2id time cost (iterations)', 0, 0, 'int'),
('auth', 'argon2_threads', '1', 'Argon2id threads (shared hosting often 1)', 0, 0, 'int'),
('auth', 'password_rehash_on_login', '1', 'Rehash passwords on login when params change', 0, 0, 'boolean')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

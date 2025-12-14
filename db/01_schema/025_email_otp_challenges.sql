CREATE TABLE  IF NOT EXISTS email_otp_challenges (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

  user_id BIGINT UNSIGNED NOT NULL,
  email VARCHAR(255) NOT NULL,

  code_hash VARBINARY(64) NOT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,

  attempts SMALLINT UNSIGNED NOT NULL DEFAULT 0,

  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  purpose VARCHAR(32) NOT NULL DEFAULT 'mfa_login',

  KEY idx_emailotp_user_active (user_id, used_at, expires_at),
  KEY idx_emailotp_email_active (email, used_at, expires_at),
  KEY idx_emailotp_expires (expires_at),
  KEY idx_emailotp_code_hash (code_hash),

  CONSTRAINT fk_emailotp_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

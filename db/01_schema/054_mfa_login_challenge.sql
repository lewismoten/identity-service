CREATE TABLE IF NOT EXISTS mfa_login_challenges (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  challenge_token_hash VARBINARY(64) NOT NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  UNIQUE KEY uq_mfa_chal_hash (challenge_token_hash),
  KEY idx_mfa_chal_user (user_id, used_at, expires_at),
  KEY idx_mfa_chal_expires (expires_at),
  CONSTRAINT fk_mfa_chal_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

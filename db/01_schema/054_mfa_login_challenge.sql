CREATE TABLE IF NOT EXISTS mfa_challenges (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  challenge_id CHAR(32) NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  expires_at DATETIME NOT NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  used_at DATETIME NULL,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  UNIQUE KEY uq_mfa_challenge (challenge_id),
  KEY idx_mfa_chal_user (user_id, used_at, expires_at),
  KEY idx_mfa_chal_expires (expires_at),
  CONSTRAINT fk_mfa_chal_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

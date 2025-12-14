CREATE TABLE IF NOT EXISTS webauthn_challenges (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

  user_id BIGINT UNSIGNED NULL,
  challenge_hash VARBINARY(64) NOT NULL,

  purpose VARCHAR(16) NOT NULL,
  rp_id VARCHAR(255) NOT NULL,
  origin VARCHAR(255) NOT NULL,

  user_handle VARBINARY(64) NULL,
  expected_cred_id VARBINARY(255) NULL,

  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,

  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,

  KEY idx_webauthn_chal_user (user_id, purpose, used_at, expires_at),
  KEY idx_webauthn_chal_expires (expires_at),
  UNIQUE KEY uq_webauthn_chal_hash (challenge_hash)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

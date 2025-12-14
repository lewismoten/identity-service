CREATE TABLE IF NOT EXISTS external_login_states (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  state_hash VARBINARY(64) NOT NULL,
  provider VARCHAR(32) NOT NULL,
  user_id BIGINT UNSIGNED NULL,
  redirect_uri VARCHAR(255) NOT NULL,
  pkce_verifier_enc VARBINARY(512) NULL,
  pkce_nonce VARBINARY(24) NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,
  KEY idx_ext_state_expires (expires_at),
  KEY idx_ext_state_provider (provider),
  UNIQUE KEY uq_ext_state_hash (state_hash),
  CONSTRAINT fk_ext_state_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

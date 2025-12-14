CREATE TABLE IF NOT EXISTS auth_sessions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  token_id CHAR(36) NOT NULL,
  refresh_token_hash VARBINARY(64) NOT NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  last_used_at DATETIME NULL,
  revoked_at DATETIME NULL,
  replaced_by_token_id CHAR(36) NULL,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  KEY idx_sessions_user (user_id),
  KEY idx_sessions_token_id (token_id),
  KEY idx_sessions_expires (expires_at),
  KEY idx_sessions_user_active (user_id, revoked_at, expires_at),
  KEY idx_sessions_user_expires (user_id, expires_at),
  KEY idx_sessions_replaced_by (replaced_by_token_id),
  KEY idx_sessions_refresh_hash (refresh_token_hash),
  UNIQUE KEY uq_sessions_token_id (token_id),
  CONSTRAINT fk_sessions_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS oauth_authorization_codes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  code_hash VARBINARY(64) NOT NULL,
  client_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  redirect_uri VARCHAR(2048) NOT NULL,
  scope VARCHAR(1024) NOT NULL,
  nonce VARCHAR(255) NULL,
  code_challenge VARCHAR(255) NULL,
  code_challenge_method ENUM('plain','S256') NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,
  auth_time DATETIME NULL,
  UNIQUE KEY uq_auth_code_hash (code_hash),
  KEY idx_auth_code_client (client_id),
  KEY idx_auth_code_user (user_id),
  KEY idx_auth_code_expires (expires_at),
  CONSTRAINT fk_auth_code_client
    FOREIGN KEY (client_id) REFERENCES oauth_clients(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_auth_code_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

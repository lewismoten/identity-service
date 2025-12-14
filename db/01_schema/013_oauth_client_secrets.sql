CREATE TABLE IF NOT EXISTS oauth_client_secrets (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id BIGINT UNSIGNED NOT NULL,
  secret_hash VARBINARY(64) NOT NULL,
  label VARCHAR(64) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  revoked_at DATETIME NULL,
  KEY idx_secret_client (client_id),
  KEY idx_secret_client_active (client_id, revoked_at, expires_at),
  CONSTRAINT fk_secret_client
    FOREIGN KEY (client_id) REFERENCES oauth_clients(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

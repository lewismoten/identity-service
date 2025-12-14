CREATE TABLE IF NOT EXISTS api_keys (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  app_id BIGINT UNSIGNED NOT NULL,
  owner_user_id BIGINT UNSIGNED NOT NULL,
  key_prefix VARCHAR(32) NOT NULL,
  key_hash VARBINARY(64) NOT NULL,
  label VARCHAR(100) NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  revoked_at DATETIME NULL,
  last_used_at DATETIME NULL,
  last_used_ip VARCHAR(45) NULL,
  last_used_user_agent VARCHAR(255) NULL,
  replaced_by_key_id BIGINT UNSIGNED NULL,
  meta JSON NULL,
  UNIQUE KEY uq_api_keys_hash (key_hash),
  UNIQUE KEY uq_api_keys_prefix (key_prefix),
  KEY idx_api_keys_app (app_id),
  KEY idx_api_keys_owner (owner_user_id),
  KEY idx_api_keys_active (owner_user_id, revoked_at, expires_at),
  KEY idx_api_keys_expires (expires_at),
  KEY idx_api_keys_last_used (last_used_at),

  CONSTRAINT fk_api_keys_app
    FOREIGN KEY (app_id) REFERENCES api_apps(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_api_keys_owner
    FOREIGN KEY (owner_user_id) REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_api_keys_replaced_by
    FOREIGN KEY (replaced_by_key_id) REFERENCES api_keys(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

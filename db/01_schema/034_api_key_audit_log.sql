CREATE TABLE IF NOT EXISTS api_key_audit_log (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  api_key_id BIGINT UNSIGNED NULL,
  app_id BIGINT UNSIGNED NULL,
  owner_user_id BIGINT UNSIGNED NULL,
  event_type VARCHAR(64) NOT NULL,
  event_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  meta JSON NULL,
  KEY idx_api_key_audit_key_time (api_key_id, event_at),
  KEY idx_api_key_audit_owner_time (owner_user_id, event_at),

  CONSTRAINT fk_api_key_audit_key
    FOREIGN KEY (api_key_id) REFERENCES api_keys(id)
    ON DELETE SET NULL,

  CONSTRAINT fk_api_key_audit_app
    FOREIGN KEY (app_id) REFERENCES api_apps(id)
    ON DELETE SET NULL,

  CONSTRAINT fk_api_key_audit_owner
    FOREIGN KEY (owner_user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS trusted_devices (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  device_id CHAR(36) NOT NULL,
  label VARCHAR(64) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_used_at DATETIME NULL,
  expires_at DATETIME NULL,
  revoked_at DATETIME NULL,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  UNIQUE KEY uq_trusted_device (user_id, device_id),
  KEY idx_trusted_user_active (user_id, revoked_at, expires_at),
  CONSTRAINT fk_trusted_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

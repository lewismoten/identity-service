CREATE TABLE IF NOT EXISTS mfa_methods (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  method VARCHAR(32) NOT NULL,
  is_enabled TINYINT(1) NOT NULL DEFAULT 0,
  is_primary TINYINT(1) NOT NULL DEFAULT 0,
  sort_order INT NOT NULL DEFAULT 0,
  is_verified TINYINT(1) NOT NULL DEFAULT 0,
  reference_id BIGINT UNSIGNED NULL,
  label VARCHAR(64) NULL,
  added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enabled_at DATETIME NULL,
  last_used_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_mfa_user (user_id),
  KEY idx_mfa_user_enabled (user_id, is_enabled),
  KEY idx_mfa_user_primary (user_id, is_primary),
  KEY idx_mfa_type (method),
  KEY idx_mfa_type (user_id, method),
  UNIQUE KEY uq_mfa_user_type_ref (user_id, method, reference_id),
  CONSTRAINT fk_mfa_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

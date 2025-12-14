CREATE TABLE IF NOT EXISTS account_lockouts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  ip_address VARCHAR(45) NULL,
  lock_reason VARCHAR(128) NOT NULL,
  locked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  locked_until DATETIME NULL,
  cleared_at DATETIME NULL,
  cleared_by_user_id BIGINT UNSIGNED NULL,
  clear_reason VARCHAR(255) NULL,
  meta JSON NULL,
  KEY idx_lockouts_user_active (user_id, cleared_at, locked_until),
  KEY idx_lockouts_ip_active (ip_address, cleared_at, locked_until),
  KEY idx_lockouts_locked_at (locked_at),
  KEY idx_lockouts_user_status (user_id, cleared_at, locked_until),
  CONSTRAINT fk_lockouts_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_lockouts_cleared_by
    FOREIGN KEY (cleared_by_user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
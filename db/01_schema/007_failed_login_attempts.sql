CREATE TABLE IF NOT EXISTS failed_login_attempts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  username VARCHAR(255) NOT NULL,
  ip_address VARCHAR(45) NOT NULL,
  attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_failed_ip_time (ip_address, attempted_at),
  KEY idx_failed_user_time (user_id, attempted_at),
  KEY idx_failed_username_time (username, attempted_at),
  CONSTRAINT fk_failed_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
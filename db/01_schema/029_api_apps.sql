CREATE TABLE IF NOT EXISTS api_apps (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

  owner_user_id BIGINT UNSIGNED NOT NULL,

  name VARCHAR(100) NOT NULL,
  description VARCHAR(255) NULL,

  is_active TINYINT(1) NOT NULL DEFAULT 1,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  KEY idx_api_apps_owner (owner_user_id),
  KEY idx_api_apps_owner_active (owner_user_id, is_active),

  CONSTRAINT fk_api_apps_owner
    FOREIGN KEY (owner_user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

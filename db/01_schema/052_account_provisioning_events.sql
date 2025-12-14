CREATE TABLE IF NOT EXISTS account_provisioning_events (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  source_type VARCHAR(16) NOT NULL,
  source_id BIGINT UNSIGNED NULL,
  actor_user_id BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  meta JSON NULL,
  UNIQUE KEY uq_provisioning_user (user_id),
  KEY idx_provisioning_actor (actor_user_id, created_at),
  KEY idx_provisioning_source (source_type, source_id),

  CONSTRAINT fk_provisioning_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_provisioning_actor
    FOREIGN KEY (actor_user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

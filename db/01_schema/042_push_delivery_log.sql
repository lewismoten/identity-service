CREATE TABLE IF NOT EXISTS push_delivery_log (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  subscription_id BIGINT UNSIGNED NULL,
  action_key VARCHAR(64) NOT NULL,
  template_id BIGINT UNSIGNED NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'queued',
  error_code VARCHAR(64) NULL,
  error_message VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_push_log_user_time (user_id, created_at),
  KEY idx_push_log_sub_time (subscription_id, created_at),
  KEY idx_push_log_action_time (action_key, created_at),
  CONSTRAINT fk_push_log_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_push_log_sub
    FOREIGN KEY (subscription_id) REFERENCES push_subscriptions(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_push_log_template
    FOREIGN KEY (template_id) REFERENCES message_templates(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

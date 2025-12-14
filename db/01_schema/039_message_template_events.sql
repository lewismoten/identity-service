CREATE TABLE IF NOT EXISTS message_template_events (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  template_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NULL,
  to_address VARCHAR(255) NULL,
  provider VARCHAR(32) NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'queued',
  error_message VARCHAR(255) NULL,
  event_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  meta JSON NULL,
  KEY idx_template_events_template_time (template_id, event_at),
  KEY idx_template_events_user_time (user_id, event_at),
  CONSTRAINT fk_template_events_template
    FOREIGN KEY (template_id) REFERENCES message_templates(id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_template_events_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

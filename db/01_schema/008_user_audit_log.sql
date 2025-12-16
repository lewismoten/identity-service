CREATE TABLE IF NOT EXISTS user_audit_log (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  event_type VARCHAR(64) NOT NULL,
  event_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  session_id BIGINT UNSIGNED NULL,
  target_user_id BIGINT UNSIGNED NULL,
  ip_anonymized_at DATETIME NULL,
  meta JSON NULL,
  KEY idx_audit_user_time (user_id, event_at),
  KEY idx_audit_type_time (event_type, event_at),
  KEY idx_audit_ip_time (ip_address, event_at),
  KEY idx_audit_session_time (session_id, event_at),
  KEY idx_audit_ip_anon_time (ip_anonymized_at, event_at),
  CONSTRAINT fk_audit_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_audit_session
    FOREIGN KEY (session_id) REFERENCES auth_sessions(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_audit_target_user
    FOREIGN KEY (target_user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
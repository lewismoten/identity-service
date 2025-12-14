CREATE TABLE IF NOT EXISTS account_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  invite_id BIGINT UNSIGNED NULL,
  requested_username VARCHAR(32) NULL,
  requested_email VARCHAR(255) NOT NULL,
  request_message VARCHAR(1000) NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'pending',
  reviewed_at DATETIME NULL,
  reviewed_by_user_id BIGINT UNSIGNED NULL,
  review_notes VARCHAR(1000) NULL,
  created_user_id BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  request_ip VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  meta JSON NULL,
  UNIQUE KEY uq_account_requests_email_active (requested_email, status),
  KEY idx_account_requests_status_time (status, created_at),
  KEY idx_account_requests_reviewed_by (reviewed_by_user_id),
  KEY idx_account_requests_created_user (created_user_id),
  CONSTRAINT fk_account_requests_reviewed_by
    FOREIGN KEY (reviewed_by_user_id) REFERENCES users(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_account_requests_created_user
    FOREIGN KEY (created_user_id) REFERENCES users(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_account_requests_invite
    FOREIGN KEY (invite_id) REFERENCES account_invites(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

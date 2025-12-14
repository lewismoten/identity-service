CREATE TABLE IF NOT EXISTS account_invites (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  invited_email VARCHAR(255) NOT NULL,
  invited_username VARCHAR(32) NULL,
  invited_by_user_id BIGINT UNSIGNED NOT NULL,
  token_hash VARBINARY(64) NOT NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  accepted_at DATETIME NULL,
  accepted_by_user_id BIGINT UNSIGNED NULL,
  revoked_at DATETIME NULL,
  revoked_by_user_id BIGINT UNSIGNED NULL,
  revoke_reason VARCHAR(255) NULL,
  invite_message VARCHAR(1000) NULL,
  meta JSON NULL,
  UNIQUE KEY uq_invites_token_hash (token_hash),
  KEY idx_invites_email_active (invited_email, accepted_at, revoked_at, expires_at),
  KEY idx_invites_inviter (invited_by_user_id, issued_at),
  KEY idx_invites_expires (expires_at),

  CONSTRAINT fk_invites_invited_by
    FOREIGN KEY (invited_by_user_id) REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_invites_accepted_by
    FOREIGN KEY (accepted_by_user_id) REFERENCES users(id)
    ON DELETE SET NULL,

  CONSTRAINT fk_invites_revoked_by
    FOREIGN KEY (revoked_by_user_id) REFERENCES users(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

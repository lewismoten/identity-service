CREATE TABLE IF NOT EXISTS webauthn_user_handles (
  user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  user_handle VARBINARY(64) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_webauthn_user_handle (user_handle),
  CONSTRAINT fk_webauthn_handle_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

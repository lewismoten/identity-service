CREATE TABLE IF NOT EXISTS external_identities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  provider VARCHAR(32) NOT NULL,
  provider_subject VARCHAR(255) NOT NULL,
  provider_email VARCHAR(255) NULL,
  email_verified TINYINT(1) NOT NULL DEFAULT 0,
  linked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login_at DATETIME NULL,
  profile JSON NULL,
  UNIQUE KEY uq_provider_subject (provider, provider_subject),
  KEY idx_external_user (user_id),
  KEY idx_external_provider_email (provider, provider_email),
  CONSTRAINT fk_external_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

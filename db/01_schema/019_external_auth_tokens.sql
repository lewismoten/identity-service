CREATE TABLE IF NOT EXISTS external_oauth_tokens (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  external_identity_id BIGINT UNSIGNED NOT NULL,

  access_token_enc VARBINARY(2048) NULL,
  refresh_token_enc VARBINARY(2048) NULL,
  token_nonce VARBINARY(24) NULL,

  scope TEXT NULL,
  token_type VARCHAR(32) NULL,
  expires_at DATETIME NULL,

  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  revoked_at DATETIME NULL,

  KEY idx_ext_tokens_identity (external_identity_id),

  CONSTRAINT fk_ext_tokens_identity
    FOREIGN KEY (external_identity_id) REFERENCES external_identities(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

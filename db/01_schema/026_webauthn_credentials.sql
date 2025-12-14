CREATE TABLE IF NOT EXISTS webauthn_credentials (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  credential_id VARBINARY(255) NOT NULL,
  public_key VARBINARY(2048) NOT NULL,
  sign_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
  aaguid CHAR(36) NULL,
  label VARCHAR(64) NULL,
  transports VARCHAR(255) NULL,
  attestation_fmt VARCHAR(32) NULL,
  is_discoverable TINYINT(1) NOT NULL DEFAULT 0,
  uv_required TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_used_at DATETIME NULL,
  revoked_at DATETIME NULL,
  UNIQUE KEY uq_webauthn_cred (credential_id),
  KEY idx_webauthn_user (user_id),
  KEY idx_webauthn_user_active (user_id, revoked_at),
  KEY idx_webauthn_last_used (last_used_at),
  CONSTRAINT fk_webauthn_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

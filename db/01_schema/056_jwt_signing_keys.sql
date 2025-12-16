CREATE TABLE IF NOT EXISTS jwt_signing_keys (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  kid VARCHAR(64) NOT NULL,
  alg VARCHAR(16) NOT NULL, -- RS256
  public_key_pem TEXT NOT NULL,

  -- optional: encrypted private key (recommended if stored in DB)
  private_key_enc LONGBLOB NULL,
  private_key_nonce VARBINARY(24) NULL,
  private_key_kid VARCHAR(64) NULL,

  is_active TINYINT(1) NOT NULL DEFAULT 1,
  active_from DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  retired_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uq_jwt_kid (kid),
  KEY idx_jwt_alg_active (alg, is_active, active_from, retired_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

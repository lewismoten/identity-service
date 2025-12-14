CREATE TABLE IF NOT EXISTS sms_verification_codes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_phone_id BIGINT UNSIGNED NOT NULL,
  code_hash VARBINARY(64) NOT NULL,
  sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,
  attempts SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  KEY idx_smsverif_phone_active (user_phone_id, used_at, expires_at),
  KEY idx_smsverif_expires (expires_at),
  KEY idx_smsverif_code_hash (code_hash),
  CONSTRAINT fk_smsverif_phone
    FOREIGN KEY (user_phone_id) REFERENCES user_phones(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

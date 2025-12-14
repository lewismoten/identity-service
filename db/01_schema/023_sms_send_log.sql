CREATE TABLE IF NOT EXISTS sms_send_log (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

  user_id BIGINT UNSIGNED NULL,
  user_phone_id BIGINT UNSIGNED NULL,

  phone_e164 VARCHAR(20) NOT NULL,
  provider VARCHAR(32) NOT NULL,
  message_type VARCHAR(32) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'queued',
  provider_message_id VARCHAR(128) NULL,

  ip_address VARCHAR(45) NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  KEY idx_smslog_phone_time (phone_e164, created_at),
  KEY idx_smslog_user_time (user_id, created_at),

  CONSTRAINT fk_smslog_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL,

  CONSTRAINT fk_smslog_phone
    FOREIGN KEY (user_phone_id) REFERENCES user_phones(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

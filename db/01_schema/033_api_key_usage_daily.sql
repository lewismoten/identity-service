CREATE TABLE IF NOT EXISTS api_key_usage_daily (
  api_key_id BIGINT UNSIGNED NOT NULL,
  day DATE NOT NULL,
  request_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
  last_request_at DATETIME NULL,
  PRIMARY KEY (api_key_id, day),
  CONSTRAINT fk_usage_key
    FOREIGN KEY (api_key_id) REFERENCES api_keys(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

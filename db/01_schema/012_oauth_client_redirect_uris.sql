CREATE TABLE IF NOT EXISTS oauth_client_redirect_uris (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id BIGINT UNSIGNED NOT NULL,
  redirect_uri VARCHAR(2048) NOT NULL,
  redirect_uri_hash BINARY(32) GENERATED ALWAYS AS (UNHEX(SHA2(redirect_uri, 256))) STORED,

  is_primary TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_client_redirect (client_id, redirect_uri_hash),
  KEY idx_redirect_client (client_id),
  CONSTRAINT fk_redirect_client
    FOREIGN KEY (client_id) REFERENCES oauth_clients(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

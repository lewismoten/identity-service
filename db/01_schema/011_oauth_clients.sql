CREATE TABLE IF NOT EXISTS oauth_clients (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(64) NOT NULL,
  client_type ENUM('public','confidential') NOT NULL DEFAULT 'public',
  name VARCHAR(128) NOT NULL,
  description VARCHAR(255) NULL,
  token_endpoint_auth_method ENUM('none','client_secret_basic','client_secret_post') NOT NULL DEFAULT 'none',
  pkce_required TINYINT(1) NOT NULL DEFAULT 1,
  allow_authorization_code TINYINT(1) NOT NULL DEFAULT 1,
  allow_refresh_token TINYINT(1) NOT NULL DEFAULT 1,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_oauth_clients_client_id (client_id),
  KEY idx_oauth_clients_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

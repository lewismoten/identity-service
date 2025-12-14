CREATE TABLE IF NOT EXISTS oauth_client_scopes (
  client_id BIGINT UNSIGNED NOT NULL,
  scope VARCHAR(64) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (client_id, scope),
  CONSTRAINT fk_client_scopes_client
    FOREIGN KEY (client_id) REFERENCES oauth_clients(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_client_scopes_scope
    FOREIGN KEY (scope) REFERENCES oauth_scopes(scope)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

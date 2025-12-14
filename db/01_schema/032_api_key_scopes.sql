CREATE TABLE IF NOT EXISTS api_key_scopes (
  api_key_id BIGINT UNSIGNED NOT NULL,
  scope VARCHAR(64) NOT NULL,
  granted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (api_key_id, scope),
  KEY idx_key_scopes_scope (scope),
  CONSTRAINT fk_key_scopes_key
    FOREIGN KEY (api_key_id) REFERENCES api_keys(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_key_scopes_scope
    FOREIGN KEY (scope) REFERENCES api_scopes(scope)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

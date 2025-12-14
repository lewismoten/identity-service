CREATE TABLE IF NOT EXISTS role_permissions (
  role_id BIGINT UNSIGNED NOT NULL,
  perm_key VARCHAR(128) NOT NULL,
  granted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (role_id, perm_key),
  KEY idx_role_perms_perm (perm_key),
  CONSTRAINT fk_role_perms_role
    FOREIGN KEY (role_id) REFERENCES roles(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_role_perms_perm
    FOREIGN KEY (perm_key) REFERENCES permissions(perm_key)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

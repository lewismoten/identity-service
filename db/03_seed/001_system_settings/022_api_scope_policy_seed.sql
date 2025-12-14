INSERT INTO system_settings
(category, name, value, description, can_delete, can_rename, format)
VALUES
('api_scope_policy', 'allow_admin_scopes', '0', 'Allow assigning admin-level scopes', 0, 0, 'boolean'),
('api_scope_policy', 'allow_write_scopes_by_default', '1', 'Allow write scopes without approval', 0, 0, 'boolean'),
('api_scope_policy', 'require_scope_review', '0', 'Require manual review for sensitive scopes', 0, 0, 'boolean')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

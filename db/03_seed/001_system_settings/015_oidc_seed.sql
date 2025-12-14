INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('oidc', 'allow_external_subjects', '1', 'Allow external provider subjects as OIDC identities', 0, 0, 'boolean'),
('oidc', 'map_external_email_claim', 'email', 'Claim used to map external email', 0, 0, 'string')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

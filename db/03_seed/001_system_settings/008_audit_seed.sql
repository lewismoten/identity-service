INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('audit','audit_login_events','1','Log login success and failure',0,0,'boolean'),
('audit','audit_token_events','1','Log session and token events',0,0,'boolean'),
('audit','audit_mfa_events','1','Log MFA enable/disable events',0,0,'boolean'),
('audit','audit_retention_days','365','Audit log retention period',0,0,'int'),
('audit','anonymize_ip_after_days','90','Anonymize IP addresses after N days',0,0,'int'),
('audit', 'audit_mfa_method_events', '1', 'Audit MFA method add/remove/enable/disable events', 0, 0, 'boolean'),
('audit', 'audit_mfa_usage_events', '1', 'Audit MFA challenge and verification events', 0, 0, 'boolean')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

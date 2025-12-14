INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('maintenance','prune_expired_sessions','1','Enable cleanup of expired sessions',0,0,'boolean'),
('maintenance','prune_expired_tokens_days','7','Grace period before deleting expired tokens',0,0,'int'),
('maintenance','prune_old_audit_logs','1','Enable audit log pruning',0,0,'boolean'),
('maintenance','prune_failed_logins_days','30','Retention for failed login attempts',0,0,'int')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('security','max_failed_logins','5','Failed logins before lockout',0,0,'int'),
('security','failed_login_window_minutes','15','Rolling window for failed logins',0,0,'int'),
('security','lockout_duration_minutes','30','Initial lockout duration',0,0,'int'),
('security','lockout_escalation_enabled','1','Enable escalating lockouts',0,0,'boolean'),
('security','max_lockout_duration_minutes','1440','Maximum lockout duration',0,0,'int'),
('security','lockout_by_ip_enabled','1','Enable IP-based lockouts',0,0,'boolean'),
('security','log_failed_logins','1','Log failed login attempts',0,0,'boolean')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

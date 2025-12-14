INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('sessions','refresh_token_ttl_days','30','Refresh token lifetime in days',0,0,'int'),
('sessions','max_sessions_per_user','10','Maximum concurrent sessions per user',0,0,'int'),
('sessions','rotate_refresh_tokens','1','Enable refresh token rotation',0,0,'boolean'),
('sessions','revoke_on_password_change','1','Revoke sessions on password change',0,0,'boolean'),
('sessions','revoke_on_mfa_change','1','Revoke sessions on MFA changes',0,0,'boolean'),
('sessions','session_idle_timeout_days','14','Expire inactive sessions after N days',0,0,'int')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('recovery','password_reset_ttl_minutes','60','Password reset token lifetime',0,0,'int'),
('recovery','max_reset_requests_per_day','5','Max password reset requests per day',0,0,'int'),
('recovery','reset_token_length','32','Reset token length in bytes',0,0,'int'),
('recovery','invalidate_sessions_on_reset','1','Revoke sessions after password reset',0,0,'boolean'),
('recovery','email_verification_ttl_hours','24','Email verification token lifetime',0,0,'int')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

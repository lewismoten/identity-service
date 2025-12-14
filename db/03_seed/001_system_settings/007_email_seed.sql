INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('email','from_address','no-reply@example.com','Default sender email address',0,1,'email'),
('email','from_name','Example App','Default sender name',0,1,'string'),
('email','enable_email_sending','1','Enable outbound email sending',0,0,'boolean'),
('email','email_rate_limit_per_hour','20','Max auth emails per hour',0,0,'int'),
('email','email_provider','smtp','Email provider type',0,1,'string')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

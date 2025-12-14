INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('jwt','access_token_ttl_seconds','900','Access token lifetime in seconds',0,0,'int'),
('jwt','issuer','https://identity.regaldragondanceparty.com','JWT issuer claim',0,1,'string'),
('jwt','audience','https://identity.regaldragondanceparty.com','JWT audience claim',0,1,'string'),
('jwt','signing_algorithm','HS256','JWT signing algorithm',0,0,'string'),
('jwt','clock_skew_seconds','60','Allowed JWT clock skew',0,0,'int'),
('jwt','include_username_claim','1','Include username in JWT payload',0,0,'boolean'),
('jwt','include_email_claim','0','Include email in JWT payload',0,0,'boolean')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

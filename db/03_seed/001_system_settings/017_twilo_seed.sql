INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('twilio', 'account_sid', '', 'Twilio Account SID', 0, 0, 'string'),
('twilio', 'auth_token', '', 'Twilio Auth Token (store outside DB if possible)', 0, 0, 'secret'),
('twilio', 'from_number_e164', '', 'Twilio sending number in E.164 format', 0, 0, 'string'),
('twilio', 'messaging_service_sid', '', 'Twilio Messaging Service SID (optional)', 1, 1, 'string')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

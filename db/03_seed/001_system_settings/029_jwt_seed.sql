INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format) VALUES
('jwt', 'signing_algorithm', 'RS256', 'JWT signing algorithm (HS256 or RS256)', 0, 0, 'string'),
('jwt', 'issuer', 'https://identity.regaldragondanceparty.com', 'JWT issuer claim', 0, 1, 'string'),
('jwt', 'audience', 'https://identity.regaldragondanceparty.com', 'JWT audience claim', 0, 1, 'string'),
('jwt', 'access_token_ttl_seconds', '900', 'Access token lifetime in seconds', 0, 0, 'int'),
('jwt', 'clock_skew_seconds', '60', 'Allowed clock skew in seconds', 0, 0, 'int'),
('jwt', 'hmac_kid', 'hmac-1', 'Key id for HS256 secret', 0, 0, 'string'),
('jwt', 'hmac_secret', '', 'HS256 secret (prefer config/env, not DB)', 0, 0, 'string'),
('jwt', 'kek_default', '', 'Hex-encoded KEK for decrypting private keys (store outside DB if possible)', 0, 0, 'string')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

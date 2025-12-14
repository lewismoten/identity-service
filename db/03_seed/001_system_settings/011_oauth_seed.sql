INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
('oauth', 'access_token_ttl_seconds', '900', 'OAuth access token lifetime (seconds)', 0, 0, 'int'),
('oauth', 'token_endpoint_rate_limit_per_minute', '60', 'Rate limit for /token endpoint per client/IP', 0, 0, 'int'),
('oauth', 'max_scopes_per_request', '20', 'Maximum scopes allowed in a single request', 0, 0, 'int')
ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

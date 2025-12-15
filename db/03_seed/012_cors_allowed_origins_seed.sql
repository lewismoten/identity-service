INSERT INTO cors_allowed_origins (origin, is_enabled, allow_credentials, notes) VALUES
('https://identity.regaldragondanceparty.com', 1, 1, 'Primary SPA'),
('https://wcf.regaldragondanceparty.com', 1, 1, 'Warren County Finances');
ON DUPLICATE KEY UPDATE
  origin = VALUES(origin);

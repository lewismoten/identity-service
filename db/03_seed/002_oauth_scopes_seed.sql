INSERT INTO oauth_scopes (scope, description, is_default, is_active)
VALUES
('openid', 'OpenID Connect scope (required for OIDC)', 0, 1),
('profile', 'Basic profile information', 1, 1),
('email', 'Email address', 0, 1)
ON DUPLICATE KEY UPDATE
  description = VALUES(description),
  is_default = VALUES(is_default),
  is_active = VALUES(is_active);

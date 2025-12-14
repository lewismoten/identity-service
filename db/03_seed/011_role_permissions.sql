-- Developer can only manage i18n debug behavior (and ideally only via user overrides)
INSERT INTO role_permissions (role_id, perm_key)
SELECT r.id, p.perm_key
FROM roles r
JOIN permissions p ON p.perm_key IN (
  'settings:i18n_debug:read',
  'settings:i18n_debug:write',
  'onboarding:invites:create',
  'onboarding:invites:view'
)
WHERE r.name = 'Developer'
ON DUPLICATE KEY UPDATE
  perm_key = VALUES(perm_key);

-- Admin can read/write system settings (system-wide)
INSERT INTO role_permissions (role_id, perm_key)
SELECT r.id, p.perm_key
FROM roles r
JOIN permissions p ON p.perm_key IN (
  'settings:system:read',
  'settings:system:write',
  'settings:i18n_debug:read',
  'settings:i18n_debug:write',
  'onboarding:requests:view',
  'onboarding:requests:review',
  'onboarding:invites:create',
  'onboarding:invites:revoke',
  'onboarding:invites:view',
  'onboarding:accounts:create'
)
WHERE r.name = 'Admin'
ON DUPLICATE KEY UPDATE
  perm_key = VALUES(perm_key);

INSERT INTO permissions (perm_key, description, category, is_active) VALUES
('settings:i18n_debug:read',  'View i18n debug settings', 'settings', 1),
('settings:i18n_debug:write', 'Modify i18n debug settings (scoped)', 'settings', 1),

('settings:system:read',  'View system settings', 'settings', 1),
('settings:system:write', 'Modify system settings', 'settings', 0),

('onboarding:requests:view',   'View account requests', 'onboarding', 1),
('onboarding:requests:review', 'Approve/deny account requests', 'onboarding', 1),

('onboarding:invites:create',  'Create/send account invitations', 'onboarding', 1),
('onboarding:invites:revoke',  'Revoke pending invitations', 'onboarding', 1),
('onboarding:invites:view',    'View invitations created by self or system', 'onboarding', 1),

('onboarding:accounts:create', 'Create accounts directly (admin-created accounts)', 'onboarding', 1)

ON DUPLICATE KEY UPDATE
  description = VALUES(description),
  category = VALUES(category),
  is_active = VALUES(is_active);

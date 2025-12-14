INSERT INTO system_settings (category, name, value, description, can_delete, can_rename, format)
VALUES
-- Master switches
('onboarding', 'allow_account_creation', '1', 'Allow creation of new accounts (global master switch)', 0, 0, 'boolean'),
('onboarding', 'allow_account_requests', '1', 'Allow users to request accounts for review', 0, 0, 'boolean'),
('onboarding', 'require_approval_for_requests', '1', 'Require manual review/approval for account requests', 0, 0, 'boolean'),

-- Registration policy (if you also support open self-register)
('onboarding', 'allow_self_registration', '0', 'Allow self-registration without an invite', 0, 0, 'boolean'),
('onboarding', 'self_registration_requires_email_verification', '1', 'Require email verification for self-registered accounts', 0, 0, 'boolean'),

-- Invite policy
('onboarding', 'allow_invites', '1', 'Allow existing users/admins to invite new users', 0, 0, 'boolean'),
('onboarding', 'invite_ttl_hours', '168', 'Invite token lifetime in hours (default 7 days)', 0, 0, 'int'),
('onboarding', 'max_pending_invites_per_inviter', '50', 'Limit pending invites per inviter', 0, 0, 'int'),

-- Request policy
('onboarding', 'request_ttl_days', '30', 'Expire pending account requests after N days', 0, 0, 'int'),
('onboarding', 'max_requests_per_email_per_day', '3', 'Rate limit: account requests per email per day', 0, 0, 'int'),

-- Review workflow
('onboarding', 'review_required_role', 'Admin', 'Role required to approve/deny account requests', 0, 1, 'string'),
('onboarding', 'default_new_user_active', '1', 'Whether approved/created users should be active by default', 0, 0, 'boolean'),

-- Invite bypass approval
('onboarding', 'invites_bypass_approval', '1', 'If enabled, invited users can create accounts without manual approval', 0, 0, 'boolean'),
('onboarding', 'invited_accounts_require_email_verification', '1', 'Require email verification for invited accounts before login', 0, 0, 'boolean'),
('onboarding', 'invites_require_permission', '1', 'If enabled, only users with onboarding:invites:create can invite', 0, 0, 'boolean'),

('onboarding', 'requests_enabled_when_creation_disabled', '0', 'If allow_account_creation=0, still allow requests (for waitlist) if set', 0, 0, 'boolean'),
('onboarding', 'review_queue_notify', '1', 'Send notification when a new account request is submitted', 0, 0, 'boolean')

ON DUPLICATE KEY UPDATE
  value = VALUES(value),
  description = VALUES(description),
  can_delete = VALUES(can_delete),
  can_rename = VALUES(can_rename),
  format = VALUES(format);

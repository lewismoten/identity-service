INSERT INTO i18n_messages (message_key, locale_tag, message_text, category, is_active)
VALUES
('auth.login.invalid_password', 'en-US', 'Invalid username or password.', 'auth', 1),
('auth.login.locked_out', 'en-US', 'Too many attempts. Try again in {minutes} minutes.', 'auth', 1),
('mfa.required', 'en-US', 'Multi-factor authentication is required.', 'mfa', 1),
('errors.rate_limited', 'en-US', 'You are doing that too often. Please wait and try again.', 'errors', 1),
('onboarding.request.submitted', 'en-US', 'Your request has been submitted for review.', 'onboarding', 1),
('onboarding.invite.accepted', 'en-US', 'Invitation accepted. Your account is ready.', 'onboarding', 1)

ON DUPLICATE KEY UPDATE
  message_text = VALUES(message_text),
  category = VALUES(category),
  is_active = VALUES(is_active);

INSERT INTO roles (name, description, is_system) VALUES
('Developer', 'Developer role; can enable debug localization features for themselves', 1),
('Admin', 'Administrative role; can manage system-wide settings', 1)
ON DUPLICATE KEY UPDATE
  description = VALUES(description),
  is_system = VALUES(is_system);

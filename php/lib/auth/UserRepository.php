<?php
declare(strict_types=1);

namespace Auth;

final class UserRepository
{
    /**
     * Fetch an active user by username or email.
     *
     * @return array|null
     */
    public function getActiveByIdentifier(string $identifier): ?array
    {
        $stmt = db()->prepare(
            "
            SELECT id, username, email, password_hash, is_active
            FROM users
            WHERE (username = :id OR email = :id)
              AND is_active = 1
            LIMIT 1
            "
        );

        $stmt->execute(['id' => $identifier]);
        $row = $stmt->fetch();

        return $row !== false ? $row : null;
    }

    public function touchLastLogin(int $userId): void
    {
        db()->prepare(
            "UPDATE users SET last_login_at = NOW() WHERE id = ?"
        )->execute([$userId]);
    }
}

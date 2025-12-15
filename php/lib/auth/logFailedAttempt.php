<?php

function logFailedAttempt(?int $userId, string $username, ?string $ip): void {
    db()->prepare("
        INSERT INTO failed_login_attempts (user_id, username, ip_address)
        VALUES (?, ?, ?)
    ")->execute([$userId, $username, $ip]);
}



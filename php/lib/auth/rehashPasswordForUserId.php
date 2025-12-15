<?php
function rehashPasswordForUserId(int $userId, string $password): void {
    $newHash = password_hash($password, PASSWORD_ARGON2ID);
    db()
      ->prepare("UPDATE users SET password_hash=? WHERE id=?")
      ->execute([$newHash, $userid]);
}
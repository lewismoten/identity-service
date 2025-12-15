<?php
function updateLastLoginForUserId(int $userid): void {
  db()
    ->prepare("UPDATE users SET last_login_at = NOW() WHERE id=?")
    ->execute([$userid]);
}
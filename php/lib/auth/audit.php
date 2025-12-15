<?php
function audit(?int $userId, string $event, ?string $ip, ?string $ua): void {
    db()->prepare("
        INSERT INTO user_audit_log
        (user_id, event_type, ip_address, user_agent)
        VALUES (?, ?, ?, ?)
    ")->execute([$userId, $event, $ip, $ua]);
}

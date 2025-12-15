<?php 
function getActiveUserByIdentifier(string $identifier): array {
  return db()
    ->prepare("
      SELECT *
      FROM users
      WHERE (username = :id OR email = :id)
        AND is_active = 1
      LIMIT 1
    ")
    ->execute([':id' => $identifier])
    ->fetch(PDO::FETCH_ASSOC);
}
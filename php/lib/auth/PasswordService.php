<?php
declare(strict_types=1);

namespace Auth;

final class PasswordService
{
  public function verify(string $password, string $hash): bool
  {
      return password_verify($password, $hash);
  }

  public function needsRehash(string $hash): bool
  {
      return password_needs_rehash(
        $hash,
        PASSWORD_ARGON2ID,
        $this->argon2Options()
      );
  }

  public function shouldRehashOnLogin(): bool
  {
      return \Settings::bool(\SettingKeys::AUTH_PASSWORD_REHASH_ON_LOGIN, true);
  }
  private function argon2Options(): array
  {
      return [
          'memory_cost' => \Settings::int(\SettingKeys::AUTH_ARGON2_MEMORY_COST, 65536),
          'time_cost'   => \Settings::int(\SettingKeys::AUTH_ARGON2_TIME_COST, 3),
          'threads'     => \Settings::int(\SettingKeys::AUTH_ARGON2_THREADS, 1),
      ];
  }
  public function rehashForUserId(int $userId, string $newPassword): void
  {
      $hash = $this->hash($newPassword);

      db()->prepare(
        "UPDATE users SET password_hash = :h WHERE id = :id LIMIT 1"
      )->execute([
        'h'  => $hash,
        'id' => $userId,
      ]);
  }

  public function hash(string $password): string
  {
      $hash = password_hash(
        $password,
        PASSWORD_ARGON2ID,
        $this->argon2Options()
      );

      if ($hash === false) {
          throw new \RuntimeException('password_hash_failed');
      }

      return $hash;
  }
}

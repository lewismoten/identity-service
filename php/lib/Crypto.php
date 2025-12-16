<?php

final class Crypto
{
  public function new_id(): string {
    return uuid_create(UUID_TYPE_RANDOM);
  }
  /**
   * Canonical binary hash for DB storage.
   * Always returns raw binary.
   */
  public function hash_bin(string $data): string {
      return hash('sha256', $data, true);
  }

  /**
   * HMAC (useful for keyed tokens or internal integrity checks).
   */
  public function hash_hmac_bin(string $data, string $key): string {
      return hash_hmac('sha256', $data, $key, true);
  }

  /**
   * Timing-safe equality for binary hashes.
   */
  public function equals(string $known_string, string $user_string): bool {
      return hash_equals($known_string, $user_string);
  }
  /**
   * Generate URL-safe random token.
   */
  public function random_token(int $bytes = 32): string {
      return rtrim(strtr(base64_encode(random_bytes($bytes)), '+/', '-_'), '=');
  }
}
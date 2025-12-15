<?php

final class Crypto
{
  public function newId(): string {
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
  public function equals(string $a, string $b): bool {
      return hash_equals($a, $b);
  }
  /**
   * Generate URL-safe random token.
   */
  public function random_token(int $bytes = 32): string {
      return rtrim(strtr(base64_encode(random_bytes($bytes)), '+/', '-_'), '=');
  }

  /**
   * Hash a public token for DB storage.
   */
  public function hash_token(string $token): string {
      return hash_bin($token);
  }
}
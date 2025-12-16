<?php
declare(strict_types=1);

namespace Auth;

interface JwtKeyStore
{
    /** Return the current active kid for the algorithm (or null) */
    public function activeKid(string $alg): ?string;

    /** Sign bytes for header.payload */
    public function sign(string $alg, ?string $kid, string $signingInput): string;

    /** Verify signature bytes for header.payload */
    public function verify(string $alg, ?string $kid, string $signingInput, string $signature): bool;
}

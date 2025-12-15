<?php
require_once __DIR__ .'/isMfaTotpEnabledByUser.php';
require_once __DIR__ .'/isMfaSmsEnabledByUser.php';
require_once __DIR__ .'/isMfaPasskeyEnabledByUser.php';
require_once __DIR__ .'/isMfaBackupCodeEnabledByUser.php';

function getAvailableMfaMethods(int $userId): array {
    $methods = [];

    if (isMfaTotpEnabledByUser($userId)) {
        $methods[] = ['type' => 'totp', 'label' => 'Authenticator app'];
    }
    if(isMfaSmsEnabledByUser($userId)) {
        $methods[] = ['type' => 'sms', 'label' => 'Text message'];
    }
    if(isMfaPasskeyEnabledByUser($userId)) {
        $methods[] = ['type' => 'webauthn', 'label' => 'Passkey'];
    }
    if(isMfaBackupCodeEnabledByUser($userId)) {
        $methods[] = ['type' => 'backup_code', 'label' => 'Backup code'];
    }

    return $methods;
}

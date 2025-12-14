# Database scripts

This folder contains SQL scripts to create and seed the Identity Service database.

## Quick start

### Option A: MySQL CLI (recommended)
From the repo root:

```bash
mysql -u YOUR_USER -p YOUR_DB_NAME < db/build.sql
```

### Option B: phpMyAdmin
If your phpMyAdmin does not support `SOURCE`, open and run each file in this order:

1. `db/01_schema/000_schema_migrations.sql`
2. `db/01_schema/001_users.sql`
3. `db/01_schema/002_user_totp.sql`
4. `db/01_schema/003_user_backup_codes.sql`
5. `db/01_schema/004_auth_sessions.sql`
6. `db/01_schema/005_password_resets.sql`
7. `db/01_schema/006_email_verifications.sql`
8. `db/01_schema/007_failed_login_attempts.sql`
9. `db/01_schema/008_user_audit_log.sql`
10. `db/01_schema/009_account_lockouts.sql`
11. `db/01_schema/010_system_settings.sql`
12. `db/03_seed/001_system_settings_seed.sql`

(Triggers are optional.)

## Notes

- All IDs are `BIGINT UNSIGNED` for type consistency across foreign keys.
- Token-like secrets are intended to be stored as hashes (VARBINARY(64)).
- TOTP secret should be stored encrypted at rest by the application (`secret_enc` + `secret_nonce`).

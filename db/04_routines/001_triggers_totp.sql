-- Optional triggers to enforce: if is_enabled=1 then secret_enc and secret_nonce must be non-NULL.
-- Use this if you can't rely on CHECK constraints being enforced on your MySQL version.

DELIMITER $$

CREATE TRIGGER user_totp_bi
BEFORE INSERT ON user_totp
FOR EACH ROW
BEGIN
  IF NEW.is_enabled = 1 AND (NEW.secret_enc IS NULL OR NEW.secret_nonce IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TOTP enabled requires secret_enc and secret_nonce';
  END IF;
END$$

CREATE TRIGGER user_totp_bu
BEFORE UPDATE ON user_totp
FOR EACH ROW
BEGIN
  IF NEW.is_enabled = 1 AND (NEW.secret_enc IS NULL OR NEW.secret_nonce IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TOTP enabled requires secret_enc and secret_nonce';
  END IF;
END$$

DELIMITER ;

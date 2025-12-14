INSERT INTO currencies (code, name, symbol, decimals, is_crypto, is_active) VALUES
('USD','US Dollar','$',2,0,1),
('EUR','Euro','€',2,0,1),
('GBP','British Pound','£',2,0,1),
('JPY','Japanese Yen','¥',0,0,1),
('BTC','Bitcoin','₿',8,1,1),
('SAT','Satoshi','sat',0,1,1)
ON DUPLICATE KEY UPDATE
  name=VALUES(name), symbol=VALUES(symbol), decimals=VALUES(decimals), is_crypto=VALUES(is_crypto), is_active=VALUES(is_active);

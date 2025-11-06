-- Bảng users + sessions (dùng salt + SHA2 cho demo)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  password_salt VARBINARY(16) NOT NULL,
  password_hash VARBINARY(32) NOT NULL, -- SHA2-256 (32 bytes)
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sessions (
  token CHAR(64) PRIMARY KEY,          -- hex 64 (32 bytes)
  user_id INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  ip VARCHAR(64),
  user_agent VARCHAR(255),
  CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB;

-- Seed admin (user=admin, pass=admin123).
SET @pass = 'admin123';
SET @salt = UNHEX(REPLACE(UUID(),'-',''));                      -- 16 bytes random
INSERT INTO users (username, password_salt, password_hash)
VALUES ('admin', @salt, UNHEX(SHA2(CONCAT(HEX(@salt), @pass), 256)))
ON DUPLICATE KEY UPDATE
  password_salt = VALUES(password_salt),
  password_hash = VALUES(password_hash);

-- BẢNG DỮ LIỆU CẢM BIẾN HIỆN TẠI (NGANG) GIẢ ĐỊNH ĐÃ CÓ:
-- CREATE TABLE sensor_data (temperature DOUBLE, humidity DOUBLE, created_at DATETIME);

-- Tùy chọn: VIEW dọc hóa từ bảng ngang (khi muốn truy vấn kiểu (device_id, metric, ...))
CREATE OR REPLACE VIEW sensor_data_v AS
SELECT 'dev01' AS device_id, 'temp' AS metric, temperature AS value, '°C' AS unit, created_at
FROM sensor_data
UNION ALL
SELECT 'dev01', 'hum',  humidity,    '%'   AS unit, created_at
FROM sensor_data;

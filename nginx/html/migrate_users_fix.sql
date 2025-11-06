-- Cho phép cột password (legacy) NULL để tránh lỗi NOT NULL khi chèn user mới
ALTER TABLE users MODIFY COLUMN password VARCHAR(255) NULL DEFAULT NULL;

-- Reset tài khoản admin (xóa nếu tồn tại rồi chèn lại với salt+SHA2)
DELETE FROM users WHERE username='admin';

SET @pass = 'admin123';
SET @salt = UNHEX(REPLACE(UUID(),'-',''));  -- 16 bytes random

-- Chèn lại user admin; để password legacy = '' (có thể đặt NULL nếu muốn)
INSERT INTO users (username, password, password_salt, password_hash, fullname)
VALUES ('admin', '', @salt, UNHEX(SHA2(CONCAT(HEX(@salt), @pass), 256)), 'Administrator');

-- Sau khi đã có dữ liệu, đặt NOT NULL cho 2 cột mới (nếu hiện tại đang NULLABLE)
ALTER TABLE users MODIFY COLUMN password_salt VARBINARY(16) NOT NULL;
ALTER TABLE users MODIFY COLUMN password_hash VARBINARY(32) NOT NULL;

CREATE TABLE IF NOT EXISTS sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  token CHAR(64) NOT NULL,
  user_id INT NOT NULL,
  expires_at DATETIME NOT NULL,
  ip VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_token (token),
  INDEX idx_user (user_id),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB;

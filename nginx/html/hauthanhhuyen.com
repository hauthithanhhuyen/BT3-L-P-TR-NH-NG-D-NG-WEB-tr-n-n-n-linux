# Site chính: hauthanhhuyen.com
server {
  listen 80;
  server_name hauthanhhuyen.com;

  # Thư mục web tĩnh
  root /usr/share/nginx/html/hauthanhhuyen.com;
  index index.html index.htm;

  access_log /var/log/nginx/hauthanhhuyen.access.log;
  error_log  /var/log/nginx/hauthanhhuyen.error.log;

  location / {
    try_files $uri $uri/ =404;
  }
}

# (Tuỳ chọn) Redirect www -> non-www
server {
  listen 80;
  server_name www.hauthanhhuyen.com;
  return 301 http://hauthanhhuyen.com$request_uri;
}

#!/bin/sh
set -e

cat > /etc/nginx/http.d/default.conf << 'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /usr/share/nginx/html;
    index index.html;

    # Preserve port in redirects
    absolute_redirect off;

    location / {
        try_files $uri $uri/ $uri/index.html =404;
    }
}
NGINX

echo "Starting nginx..."
exec nginx -g "daemon off;"

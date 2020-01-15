server {
  server_name johngorman.io; # managed by Certbot
  root /u/jgio/johngorman-io/_site;
  passenger_enabled on;

  location /darkest-night-clock/run {
    alias /u/jgio/darkest-night-clock-react-js/build;
  }

  location /summary {
    proxy_pass http://localhost:3000;
  }

  location ~ ^/wifi-service {
    rewrite ^/wifi-service/(.*) /$1 break;
    passenger_app_type node;
    passenger_app_root /u/jgio/wifi-watch/wifi-service;
    passenger_startup_file app.js;
  }

  location /activity-cable {
    passenger_app_group_name activity-cable;
    passenger_force_max_concurrent_requests_per_process 0;
    passenger_app_root /u/jgio/activity-timer/current;
  }

  location ~ ^/activity(/.*|$) {
    alias /u/jgio/activity-timer/current/public$1;
    passenger_base_uri /activity;
    passenger_app_root /u/jgio/activity-timer/current;
    passenger_document_root /u/jgio/activity-timer/current/public;
  }

  index index.html;
  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    try_files $uri $uri/ =404;
  }

  listen [::]:443 ssl http2 ipv6only=on; # managed by Certbot
  listen 443 ssl http2; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/johngorman.io/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/johngorman.io/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
  if ($host = johngorman.io) {
    return 301 https://$host$request_uri;
  } # managed by Certbot

  listen 80 ;
  listen [::]:80 ;
  server_name johngorman.io;
  return 404; # managed by Certbot
}

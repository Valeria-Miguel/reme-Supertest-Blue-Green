#!/bin/bash
set -e
ENV=$1

if [ "$ENV" = "blue" ]; then
  PORT=3001
else
  PORT=3002
fi

echo "Switching traffic to $ENV (port $PORT)"

sudo sed -i "s|server 127.0.0.1:[0-9]*|server 127.0.0.1:$PORT|" /etc/nginx/sites-available/app.conf

sudo nginx -t && sudo systemctl reload nginx
echo "Tráfico cambiado a $ENV"

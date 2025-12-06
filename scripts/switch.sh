#!/bin/bash
set -e
ENV=$1

if [ "$ENV" = "blue" ]; then
  PORT=3001
  FRONTEND="frontend-blue"
else
  PORT=3002
  FRONTEND="frontend-green"
fi

echo "Switching to $ENV (port $PORT, frontend $FRONTEND)"

sudo sed -i "s|server 127.0.0.1:[0-9]*|server 127.0.0.1:$PORT|" /etc/nginx/sites-available/app.conf
sudo sed -i "s|frontend-[a-z]*|frontend-$ENV|" /etc/nginx/sites-available/app.conf

sudo nginx -t && sudo systemctl reload nginx
echo "Tráfico cambiado a $ENV"
#!/bin/bash
set -e

NGINX_CONF="/etc/nginx/sites-available/app.conf"

if [ "$1" = "blue" ]; then
  TARGET_PORT=3100
elif [ "$1" = "green" ]; then
  TARGET_PORT=3101
else
  echo "Uso: ./switch.sh [blue|green]"
  exit 1
fi

sudo cp $NGINX_CONF $NGINX_CONF.bak
sudo sed -i "/upstream app_upstream {/,/}/s/server 127.0.0.1:[0-9]*/server 127.0.0.1:$TARGET_PORT/" $NGINX_CONF
sudo nginx -t || { echo "nginx config error"; exit 1; }
sudo systemctl reload nginx

echo "Switch realizado a $TARGET_PORT"

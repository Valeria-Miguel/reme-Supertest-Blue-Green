#!/bin/bash
set -e

NGINX_CONF="/etc/nginx/conf.d/app.conf"
TARGET_CONTAINER="nginx_proxy_reme"

if [ "$1" = "blue" ]; then
  TARGET_PORT=3100
elif [ "$1" = "green" ]; then
  TARGET_PORT=3101
else
  echo "Uso: ./switch.sh [blue|green]"
  exit 1
fi

docker exec $TARGET_CONTAINER sed -i "/upstream reme_upstream {/,/}/s/server 127.0.0.1:[0-9]*/server 127.0.0.1:$TARGET_PORT/" $NGINX_CONF
docker exec $TARGET_CONTAINER nginx -t
docker exec $TARGET_CONTAINER nginx -s reload

echo "Switch realizado a $TARGET_PORT"

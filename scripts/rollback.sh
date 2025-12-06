#!/bin/bash
set -e

NGINX_CONF="/etc/nginx/sites-available/app.conf"

sudo cp $NGINX_CONF $NGINX_CONF.bak
sudo sed -i "/upstream app_upstream {/,/}/s/server 127.0.0.1:[0-9]*/server 127.0.0.1:3100/" $NGINX_CONF
sudo nginx -t || { echo "nginx config error"; exit 1; }
sudo systemctl reload nginx

echo "Rollback completado (apunta a Blue por defecto)"

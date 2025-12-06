#!/bin/bash
set -e

# Detecta el contenedor activo y revierte
NGINX_CONF="/etc/nginx/sites-available/app.conf"

# Por simplicidad, revertimos a blue
sudo sed -i "/upstream app_upstream {/,/}/s/server 127.0.0.1:[0-9]*/server 127.0.0.1:3001/" $NGINX_CONF
sudo nginx -t
sudo systemctl reload nginx

echo "Rollback realizado → Blue (puerto 3001)"

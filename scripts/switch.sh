#!/bin/bash
set -e

# Uso: ./switch.sh [blue|green]
ENV=$1

if [ "$ENV" = "blue" ]; then
    PORT=3001
elif [ "$ENV" = "green" ]; then
    PORT=3002
else
    echo "Uso: ./switch.sh [blue|green]"
    exit 1
fi

NGINX_CONF="/etc/nginx/sites-available/app.conf"

# Actualiza el upstream al puerto correcto
sudo sed -i "/upstream app_upstream {/,/}/s/server 127.0.0.1:[0-9]*/server 127.0.0.1:$PORT/" $NGINX_CONF

# Test y recarga
sudo nginx -t || { echo "Error en configuración Nginx"; exit 1; }
sudo systemctl reload nginx

echo "Switch realizado → $ENV (puerto $PORT)"

#!/bin/bash

CONF="/etc/nginx/sites-available/app.conf"

echo "=== ESTADO BLUE-GREEN DEPLOYMENT ==="
echo

echo "Contenedores activos:"
docker ps --filter "name=app-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo

echo "Nginx - Upstream activo:"
grep "server 127.0.0.1" $CONF | head -1
echo

echo "Health check Blue (3001):"
curl -s http://127.0.0.1:3001 || echo "No responde"
echo

echo "Health check Green (3002):"
curl -s http://127.0.0.1:3002 || echo "No responde"
echo

echo "Servicio público (Nginx):"
curl -s http://127.0.0.1/health || echo "Inactivo"
echo

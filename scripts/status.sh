#!/bin/bash
set -e

echo "Contenedores relevantes:"
docker ps --filter "name=frutas-" --format "table {{.Names}}	{{.Status}}	{{.Ports}}"

echo "Upstream Nginx:"
grep -A1 "upstream app_upstream" /etc/nginx/sites-available/app.conf | grep "server"

echo "Health checks:"
echo -n "Blue (3100): "
curl -s http://127.0.0.1:3100/health || echo "No responde"
echo -n "Green (3101): "
curl -s http://127.0.0.1:3101/health || echo "No responde"
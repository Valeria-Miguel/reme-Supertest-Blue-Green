#!/bin/bash
set -e

ENVIRONMENT=$1
IMAGE="ghcr.io/valeria-miguel/reme-supertest-blue-green:latest"

if [ "$ENVIRONMENT" == "blue" ]; then
  PORT=3100
  CONTAINER_NAME="frutas-blue"
elif [ "$ENVIRONMENT" == "green" ]; then
  PORT=3101
  CONTAINER_NAME="frutas-green"
else
  echo "Usage: ./deploy.sh [blue|green]"
  exit 1
fi

echo "Desplegando $ENVIRONMENT en puerto $PORT"

# Eliminar contenedor previo si existe
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Descargar imagen
docker pull $IMAGE || true

# Crear nuevo contenedor
docker run -d \
  --name $CONTAINER_NAME \
  -p $PORT:3000 \
  --restart unless-stopped \
  $IMAGE

# Esperar a que la app se levante
sleep 5

# Health check
if curl -s http://127.0.0.1:$PORT/health | grep -q 'OK'; then
  echo "Healthy. Switching Nginx upstream..."
  ./switch.sh $ENVIRONMENT
else
  echo "❌ Health check failed."
  docker logs $CONTAINER_NAME --tail 200
  exit 1
fi

echo "Deploy de $ENVIRONMENT completado."

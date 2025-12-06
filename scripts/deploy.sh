#!/bin/bash
set -e

ENV=$1
IMAGE="ghcr.io/valeria-miguel/reme-supertest-blue-green:latest"

if [ "$ENV" = "blue" ]; then
  PORT=3001
  CONTAINER="frutas-blue"
else
  PORT=3002
  CONTAINER="frutas-green"
fi

echo "Deploying $ENV → puerto $PORT"

# Liberar el puerto si está ocupado por cualquier contenedor
# 🔧 IMPORTANTE: solo el puerto, sin 0.0.0.0:
OCCUPIED=$(docker ps -q --filter "publish=$PORT")

if [ -n "$OCCUPIED" ]; then
  docker rm -f $OCCUPIED
fi

docker rm -f $CONTAINER 2>/dev/null || true
docker pull $IMAGE
docker run -d --name $CONTAINER -p $PORT:3000 --restart unless-stopped $IMAGE

sleep 8

# Healthcheck contra el puerto del host
if curl -sf http://127.0.0.1:$PORT/health; then
  echo "Healthy → switching"
  ./scripts/switch.sh $ENV
else
  echo "Health failed"
  docker logs $CONTAINER --tail 50
  exit 1
fi

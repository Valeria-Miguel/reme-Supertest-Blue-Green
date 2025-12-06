#!/bin/bash
set -e

ENV=$1
IMAGE="ghcr.io/valeria-miguel/reme-supertest-blue-green:latest"

if [ "$ENV" = "blue" ]; then
  PORT=3001
  CONTAINER="frutas-blue"
  FRONTEND="frontend-blue"
else
  PORT=3002
  CONTAINER="frutas-green"
  FRONTEND="frontend-green"
fi

echo "Deploying $ENV → puerto $PORT, frontend en $FRONTEND"

# Blue-Green para frontend
rm -rf /home/dulce/reme-Supertest-Blue-Green/$FRONTEND
cp -r /home/dulce/reme-Supertest-Blue-Green/frontend /home/dulce/reme-Supertest-Blue-Green/$FRONTEND

# Backend contenedor
docker rm -f $CONTAINER 2>/dev/null || true
docker pull $IMAGE
docker run -d --name $CONTAINER -p $PORT:3000 --restart unless-stopped $IMAGE

sleep 8

if curl -sf http://127.0.0.1:$PORT/health; then
  echo "Healthy → switching"
  ./scripts/switch.sh $ENV
else
  echo "Health failed"
  docker logs $CONTAINER --tail 50
  exit 1
fi
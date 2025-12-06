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

docker rm -f $CONTAINER_NAME 2>/dev/null || true

docker pull $IMAGE || true

docker run -d --name $CONTAINER_NAME -p $PORT:3000 --restart unless-stopped $IMAGE

echo "Listo"

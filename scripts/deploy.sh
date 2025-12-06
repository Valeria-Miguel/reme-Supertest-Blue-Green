#!/bin/bash
set -e
ENVIRONMENT=$1
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

IMAGE="$1"

echo "Desplegando $ENVIRONMENT en puerto $PORT"

docker rm -f $CONTAINER_NAME 2>/dev/null || true

docker pull ghcr.io/${GITHUB_OWNER}/${GITHUB_REPO}:latest || true

docker run -d --name $CONTAINER_NAME -p $PORT:3000 --restart unless-stopped ghcr.io/${GITHUB_OWNER}/${GITHUB_REPO}:latest

echo "Listo"
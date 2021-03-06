#!/bin/bash

export COMPOSE_FILE=docker-compose.yaml
export COMPOSE_PROJECT_NAME="aqui"

docker-compose -f $COMPOSE_FILE down

DOCKER_IMAGE_IDS=$(docker images | grep "dev\|none\|test-vp\|peer[0-9]-" | awk '{print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "---- No images available for deletion ----"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
  
#rm -rf channel-artifacts/*

docker-compose -f $COMPOSE_FILE stop

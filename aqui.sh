#!/bin/bash

# Exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

#mkdir channel-artifacts

export FABRIC_CFG_PATH=$PWD
export CHANNEL_NAME="mychannel"
export CLI_TIMEOUT=12000
export CLI_DELAY=3
export LANGUAGE=golang
export FABRIC_START_TIMEOUT=3

# Pass -d to see real-time logs
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d ca.example.com 
sleep ${FABRIC_START_TIMEOUT}
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d orderer.example.com 
sleep ${FABRIC_START_TIMEOUT}
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d peer0.org1.example.com 
sleep ${FABRIC_START_TIMEOUT}
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d peer1.org1.example.com 
sleep ${FABRIC_START_TIMEOUT}
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d peer0.org2.example.com 
sleep ${FABRIC_START_TIMEOUT}
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d peer1.org2.example.com
sleep ${FABRIC_START_TIMEOUT}
COMPOSE_PROJECT_NAME=aqui COMPOSE_HTTP_TIMEOUT=12000 docker-compose -f docker-compose.yaml up -d cli

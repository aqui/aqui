#!/bin/bash

rm -r channel-artifacts

mkdir channel-artifacts

export FABRIC_CFG_PATH=$PWD
export CHANNEL_NAME="mychannel"
export CLI_TIMEOUT=12000
export CLI_DELAY=3
export COMPOSE_FILE=docker-compose-cli.yaml
export LANGUAGE=golang
export COMPOSE_HTTP_TIMEOUT=12000
export COMPOSE_PROJECT_NAME="aqui"

# Generate certificates using cryptogen tool
cryptogen generate --config=./crypto-config.yaml

# Generate Orderer Genesis block
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

# Generating channel configuration transaction channel.tx
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

# Generating anchor peer update for Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

# Generating anchor peer update for Org2MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

# Pass -d to see real-time logs
docker-compose -f $COMPOSE_FILE up

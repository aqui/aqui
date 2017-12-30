#!/bin/bash

rm -r channel-artifacts

mkdir channel-artifacts

export FABRIC_CFG_PATH=.
export CHANNEL_NAME="mychannel"
export CLI_TIMEOUT=10
export CLI_DELAY=3
export COMPOSE_FILE=docker-compose-cli.yaml
export LANGUAGE=golang

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

docker-compose -f $COMPOSE_FILE up -d 2>&1

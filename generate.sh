#!/bin/bash

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME="mychannel"

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

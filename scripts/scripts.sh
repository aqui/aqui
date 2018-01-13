#!/bin/bash

#Enter to cli container
#docker exec -it cli bash

CHANNEL_NAME=mychannel
TIMEOUT=12000
LANGUAGE=golang
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CC_SRC_PATH="github.com/chaincode/go/"
DELAY=3

#Create channel
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile $ORDERER_CA

#Join peer0.org1.example.com to the channel
peer channel join -b mychannel.block

sleep $DELAY

#Join peer0.org2.example.com to the channel
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp CORE_PEER_ADDRESS=peer0.org2.example.com:7051 
CORE_PEER_LOCALMSPID="Org2MSP" 
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt 
peer channel join -b mychannel.block

#Install chaincode
peer chaincode install -n mycc -v 1.0 -p $CC_SRC_PATH

sleep $DELAY

#Instantiate chaincode
peer chaincode instantiate -o orderer.example.com:7050 --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR ('Org1MSP.member', 'Org2MSP.member')"

mv mychannel.block channel-artifacts/

sleep $DELAY

peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'

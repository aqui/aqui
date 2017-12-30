#!/bin/bash

#Prerequisites
#sudo apt-get install curl
#sudo apt-get install wget
#sudo apt-get install tar
#sudo apt-get install docker
#sudo apt-get install docker-composer
#sudo wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
#sudo tar -zxvf  go1.7.1.linux-amd64.tar.gz -C /usr/local/
#curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
#sudo apt-get install -y nodejs
#sudo apt-get install -y build-essential
#sudo npm install npm@3.10.10 -g

export VERSION=${1:-1.0.4}
export CA_VERSION=${2:-$VERSION}
export ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
MARCH=`uname -m`
: ${CA_TAG:="$MARCH-$CA_VERSION"}
: ${FABRIC_TAG:="$MARCH-$VERSION"}

#Docker images
docker pull hyperledger/fabric-peer:$FABRIC_TAG
docker pull hyperledger/fabric-orderer:$FABRIC_TAG
docker pull hyperledger/fabric-couchdb:$FABRIC_TAG
docker pull hyperledger/fabric-ccenv:$FABRIC_TAG
docker pull hyperledger/fabric-javaenv:$FABRIC_TAG
docker pull hyperledger/fabric-kafka:$FABRIC_TAG
docker pull hyperledger/fabric-zookeeper:$FABRIC_TAG
docker pull hyperledger/fabric-tools:$FABRIC_TAG
docker pull hyperledger/fabric-ca:$CA_TAG

#Tag Docker images
docker tag hyperledger/fabric-peer:$FABRIC_TAG hyperledger/fabric-peer
docker tag hyperledger/fabric-orderer:$FABRIC_TAG hyperledger/fabric-orderer
docker tag hyperledger/fabric-couchdb:$FABRIC_TAG hyperledger/fabric-couchdb
docker tag hyperledger/fabric-ccenv:$FABRIC_TAG hyperledger/fabric-ccenv
docker tag hyperledger/fabric-javaenv:$FABRIC_TAG hyperledger/fabric-javaenv
docker tag hyperledger/fabric-kafka:$FABRIC_TAG hyperledger/fabric-kafka
docker tag hyperledger/fabric-zookeeper:$FABRIC_TAG hyperledger/fabric-zookeeper
docker tag hyperledger/fabric-tools:$FABRIC_TAG hyperledger/fabric-tools
docker tag hyperledger/fabric-ca:$CA_TAG hyperledger/fabric-ca

#Binaries
curl https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${ARCH}-${VERSION}/hyperledger-fabric-${ARCH}-${VERSION}.tar.gz | tar xz -C $HOME/Apps/hyperledger

#Append to the /etc/profile
#sudo echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
#sudo echo "export GOPATH=$HOME/workspace" >> /etc/profile
#sudo echo "export PATH=$PATH:$HOME/Apps/hyperledger/bin" >> /etc/profile 

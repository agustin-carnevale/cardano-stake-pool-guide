#!/bin/bash

BP_IP=""
BP_PORT=
NWMAGIC="1097911063"
CONFIG_PATH="/home/ubuntu/my-cardano-staking-pool/cardano-node/config/testnet"

curl -4 -s -o /home/ubuntu/scripts/output-files/updatedTopology.json "https://api.clio.one/htopology/v1/fetch/?max=15&magic=${NWMAGIC}&ipv=4&customPeers=${BP_IP}:${BP_PORT}:1|relays-new.cardano-testnet.iohkdev.io:3001:2"

cp "${CONFIG_PATH}/testnet-topology.json" "${CONFIG_PATH}/backup-files/testnet-topology_$(date +%F).json"
cp /home/ubuntu/scripts/output-files/updatedTopology.json "${CONFIG_PATH}/testnet-topology.json"
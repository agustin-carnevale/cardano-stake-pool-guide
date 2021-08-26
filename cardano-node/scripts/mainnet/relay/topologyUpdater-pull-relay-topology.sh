#!/bin/bash

BP_IP=""
BP_PORT=
NWMAGIC="764824073"
CONFIG_PATH="/home/ubuntu/my-cardano-staking-pool/cardano-node/config/mainnet"

curl -4 -s -o /home/ubuntu/scripts/output-files/updatedTopology.json "https://api.clio.one/htopology/v1/fetch/?max=15&magic=${NWMAGIC}&ipv=4&customPeers=${BP_IP}:${BP_PORT}:1|relays-new.cardano-mainnet.iohk.io:3001:2"

cp "${CONFIG_PATH}/mainnet-topology.json" "${CONFIG_PATH}/backup-files/mainnet-topology_$(date +%F).json"
cp /home/ubuntu/scripts/output-files/updatedTopology.json "${CONFIG_PATH}/mainnet-topology.json"
#!/bin/bash

CNODE_HOSTNAME=""
CNODE_PORT=
CNODE_VALENCY=1
CNODE_HOME="/home/ubuntu/scripts"
LOG_DIR="${CNODE_HOME}/logs"

NWMAGIC="1097911063"
NETWORK_IDENTIFIER="--testnet-magic ${NWMAGIC}"

blockNo=$(/snap/bin/docker exec cardano-node-testnet bash -c \
        "/usr/local/bin/cardano-cli query tip ${NETWORK_IDENTIFIER} | jq -r .block")

#echo $blockNo

if [ ! -d ${LOG_DIR} ]; then
  mkdir -p ${LOG_DIR};
fi

curl -s -f -4 "https://api.clio.one/htopology/v1/?port=${CNODE_PORT}&blockNo=${blockNo}&valency=${CNODE_VALENCY}&magic=${NWMAGIC}&hostname=${CNODE_HOSTNAME}" | tee -a "${LOG_DIR}"/topologyUpdater_lastresult.json
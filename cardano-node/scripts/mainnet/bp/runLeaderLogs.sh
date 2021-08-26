#!/bin/bash

# Dependencies: you need to have installed cncli and jq on the host machine.
# sudo apt update && sudo apt install jq

#Usage:
#./runLeaderLogs.sh       (for current epoch)
#./runLeaderLogs.sh next  (for next epoch, 70% of current epoch is required)
#./runLeaderLogs.sh prev  (for previous epoch)

#fill with your pool id and BP port
POOL_ID=""
NWMAGIC=764824073 
BP_PORT=

#fill the path to these files and pool name
POOL_VRF_SKEY="/home/....<fill-in-path>...../.keys/mainnet/<pool-name>.vrf.skey"
BYRON_GENESIS="/home/....<fill-in-path>.../config/mainnet/mainnet-byron-genesis.json"
SHELLEY_GENESIS="/home/....<fill-in-path>.../config/mainnet/mainnet-shelley-genesis.json"

#change DB file name and path to cncli dir as needed
PATH_TO_CNCLI_DIR="/home/ubuntu/cncli"
CNCLI_DB="cncli.db"

# ---------- DO NOT EDIT BELOW THIS LINE ----------- #

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

echo -e "${YELLOW}-->${GREEN}Starting up${NC}.."

LEADER_SET="current"
pool_stake_key='.poolStakeSet'
active_stake_key='.activeStakeSet'

if [[ $1 == "next" ]]; then
  LEADER_SET="next"
  pool_stake_key='.poolStakeMark'
  active_stake_key='.activeStakeMark'

elif [[ $1 == "prev" ]]; then
  LEADER_SET="prev"
  pool_stake_key='.poolStakeGo'
  active_stake_key='.activeStakeGo'
fi


echo -e "${YELLOW}-->${GREEN}Taking stake snapshot${NC}.."

#only change path to docker bin,cardano-cli bin and container name if needed
snapshot=$(/snap/bin/docker exec cardano-node-mainnet bash -c \
       	"/usr/local/bin/cardano-cli query stake-snapshot --stake-pool-id ${POOL_ID} --mainnet")

POOL_STAKE=$(jq -r "${pool_stake_key}" <<< ${snapshot})
ACTIVE_STAKE=$(jq -r "${active_stake_key}" <<< ${snapshot})


echo -e "${YELLOW}-->${GREEN}Syncing DB${NC}.."

cd $PATH_TO_CNCLI_DIR && cncli sync --no-service --network-magic $NWMAGIC --host 127.0.0.1 -p $BP_PORT --db $CNCLI_DB

echo -e "${YELLOW}-->${GREEN}Processing leaderlogs please wait${NC}..."

cncli leaderlog --db $CNCLI_DB --pool-id $POOL_ID --pool-vrf-skey $POOL_VRF_SKEY   \
 --byron-genesis $BYRON_GENESIS    \
 --shelley-genesis $SHELLEY_GENESIS \
 --pool-stake $POOL_STAKE            \
 --active-stake $ACTIVE_STAKE         \
 --ledger-set $LEADER_SET
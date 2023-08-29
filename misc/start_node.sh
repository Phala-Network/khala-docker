#!/bin/bash

WORK_PATH=$(dirname $(readlink -f "$0"))
DATA_PATH="$HOME/data"

NODE_NAME="${NODE_NAME:-"khala-dev-node"}"
NODE_ROLE="${NODE_ROLE:-""}"

PARACHAIN="$WORK_PATH/thala-local-2004-raw.chain_spec.json"
RELAYCHAIN="$WORK_PATH/rococo-local-raw.chain_spec.json"

case ${NODE_ROLE} in
  "")
    echo "You must set NODE_ROLE env"
    echo "accept values (case sensitive): <Empty> | FULL | ARCHIVE | COLLATOR | MINER"
    exit 1
    ;;
  "FULL")
    PARACHAIN_ROLE_ARGS=""
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "ARCHIVE")
    PARACHAIN_ROLE_ARGS="--pruning archive"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "COLLATOR")
    PARACHAIN_ROLE_ARGS="--collator --rpc-external --rpc-methods Unsafe"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "MINER")
    PARACHAIN_ROLE_ARGS="--pruning archive --rpc-external --rpc-methods Unsafe"
    RELAYCHAIN_ROLE_ARGS="--pruning archive --rpc-external --rpc-methods Unsafe"
    ;;
  *)
    echo "Unknown NODE_ROLE ${NODE_ROLE}"
    echo "accept values (case sensitive): <Empty> | FULL | ARCHIVE | COLLATOR | MINER"
    exit 1
    ;;
esac

echo "Starting Khala node as role '${NODE_ROLE}' with extra parachain args '${PARACHAIN_EXTRA_ARGS}' extra relaychain args '${RELAYCHAIN_EXTRA_ARGS}'"

$WORK_PATH/khala-node \
  --chain $PARACHAIN \
  --base-path $DATA_PATH \
  --name $NODE_NAME \
  --port 30333 \
  --prometheus-port 9615 \
  --rpc-port 9933 \
  --ws-port 9944 \
  --prometheus-external \
  --ws-external \
  --rpc-cors all \
  $PARACHAIN_ROLE_ARGS \
  $PARACHAIN_EXTRA_ARGS \
  -- \
  --chain $RELAYCHAIN \
  --port 30334 \
  --prometheus-port 9616 \
  --rpc-port 9934 \
  --ws-port 9945 \
  --prometheus-external \
  --ws-external \
  --rpc-cors all \
  $RELAYCHAIN_ROLE_ARGS \
  $RELAYCHAIN_EXTRA_ARGS
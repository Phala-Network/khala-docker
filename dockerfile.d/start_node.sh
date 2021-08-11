#!/bin/bash

WORK_PATH=$(dirname $(readlink -f "$0"))
DATA_PATH="$HOME/data"

NODE_NAME="${NODE_NAME:-"khala-node"}"
NODE_ROLE="${NODE_ROLE:-""}"

PARACHAIN="khala"
RELAYCHAIN="kusama"

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
    PARACHAIN_ROLE_ARGS="--collator"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "MINER")
    PARACHAIN_ROLE_ARGS="--pruning archive --ws-external --rpc-external --rpc-cors all --rpc-methods Unsafe"
    RELAYCHAIN_ROLE_ARGS="--pruning archive --ws-external --rpc-external --rpc-cors all --rpc-methods Unsafe"
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
  $PARACHAIN_ROLE_ARGS \
  $PARACHAIN_EXTRA_ARGS \
  -- \
  --chain $RELAYCHAIN \
  --port 30334 \
  --prometheus-port 9616 \
  --rpc-port 9934 \
  --ws-port 9945 \
  --prometheus-external \
  $RELAYCHAIN_ROLE_ARGS \
  $RELAYCHAIN_EXTRA_ARGS
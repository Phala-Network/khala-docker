#!/bin/bash

DATA_PATH="$HOME/data"

NODE_NAME="${NODE_NAME:-"khala-node"}"
NODE_ROLE="${NODE_ROLE:-""}"

PARACHAIN_PORT="${PARACHAIN_PORT:-"30333"}"
RELAYCHAIN_PORT="${RELAYCHAIN_PORT:-"30334"}"

PARACHAIN_DB="${PARACHAIN_DB:-"rocksdb"}"
RELAYCHAIN_DB="${RELAYCHAIN_DB:-"rocksdb"}"

PARACHAIN="${PARACHAIN:-"khala"}"
RELAYCHAIN="${RELAYCHAIN:-"kusama"}"

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
    PARACHAIN_ROLE_ARGS="--pruning archive --rpc-external"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "COLLATOR")
    PARACHAIN_ROLE_ARGS="--collator --pruning archive --rpc-external --rpc-methods unsafe"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "MINER")
    PARACHAIN_ROLE_ARGS="--pruning archive --rpc-external --rpc-methods unsafe"
    RELAYCHAIN_ROLE_ARGS="--pruning archive --rpc-external --rpc-methods unsafe"
    ;;
  *)
    echo "Unknown NODE_ROLE ${NODE_ROLE}"
    echo "accept values (case sensitive): <Empty> | FULL | ARCHIVE | COLLATOR | MINER"
    exit 1
    ;;
esac

echo "Starting Khala node as role '${NODE_ROLE}' with extra parachain args '${PARACHAIN_EXTRA_ARGS}' extra relaychain args '${RELAYCHAIN_EXTRA_ARGS}'"

/usr/local/bin/khala-node \
  --chain $PARACHAIN \
  --base-path $DATA_PATH \
  --database $PARACHAIN_DB \
  --name $NODE_NAME \
  --port $PARACHAIN_PORT \
  --prometheus-port 9615 \
  --rpc-port 9933 \
  --ws-port 9944 \
  --prometheus-external \
  --ws-external \
  --rpc-cors all \
  --no-hardware-benchmarks \
  $PARACHAIN_ROLE_ARGS \
  $PARACHAIN_EXTRA_ARGS \
  -- \
  --chain $RELAYCHAIN \
  --database $RELAYCHAIN_DB \
  --port $RELAYCHAIN_PORT \
  --prometheus-port 9616 \
  --rpc-port 9934 \
  --ws-port 9945 \
  --prometheus-external \
  --ws-external \
  --rpc-cors all \
  --no-hardware-benchmarks \
  $RELAYCHAIN_ROLE_ARGS \
  $RELAYCHAIN_EXTRA_ARGS

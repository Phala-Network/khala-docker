#!/bin/bash

DATA_PATH="$HOME/data"

NODE_NAME="${NODE_NAME:-"khala-node"}"
NODE_ROLE="${NODE_ROLE:-""}"

PARACHAIN="${PARACHAIN:-"phala"}"
RELAYCHAIN="${RELAYCHAIN:-"polkadot"}"

PARACHAIN_DB="${PARACHAIN_DB:-"paritydb"}"
RELAYCHAIN_DB="${RELAYCHAIN_DB:-"paritydb"}"

PARACHAIN_LIBP2P_PORT="${PARACHAIN_LIBP2P_PORT:-"30333"}"
RELAYCHAIN_LIBP2P_PORT="${RELAYCHAIN_LIBP2P_PORT:-"30334"}"

PARACHAIN_PROMETHEUS_PORT="${PARACHAIN_PROMETHEUS_PORT:-"9615"}"
RELAYCHAIN_PROMETHEUS_PORT="${RELAYCHAIN_PROMETHEUS_PORT:-"9616"}"

PARACHAIN_RPC_PORT="${PARACHAIN_RPC_PORT:-"9944"}"
RELAYCHAIN_RPC_PORT="${RELAYCHAIN_RPC_PORT:-"9945"}"

PARACHAIN_UNSAFE_RPC="--rpc-methods unsafe"
RELAYCHAIN_UNSAFE_RPC="--rpc-methods unsafe"

PARACHAIN_EXPOSE_ENDPOINTS="--rpc-external --prometheus-external --rpc-cors all"
RELAYCHAIN_EXPOSE_ENDPOINTS="--rpc-external --prometheus-external --rpc-cors all"

case ${NODE_ROLE} in
  "")
    echo "You must set NODE_ROLE env"
    echo "accept values (case sensitive): FULL | ARCHIVE | COLLATOR | MINER"
    exit 1
    ;;
  "FULL")
    PARACHAIN_ROLE_ARGS=""
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "ARCHIVE")
    PARACHAIN_ROLE_ARGS="--blocks-pruning archive-canonical --state-pruning archive-canonical"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "COLLATOR")
    PARACHAIN_ROLE_ARGS="--collator"
    RELAYCHAIN_ROLE_ARGS=""
    ;;
  "MINER")
    PARACHAIN_ROLE_ARGS="--blocks-pruning archive-canonical --state-pruning archive-canonical"
    RELAYCHAIN_ROLE_ARGS="--blocks-pruning archive-canonical --state-pruning archive-canonical"
    ;;
  *)
    echo "Unknown NODE_ROLE ${NODE_ROLE}"
    echo "accept values (case sensitive): FULL | ARCHIVE | COLLATOR | MINER"
    exit 1
    ;;
esac

echo "Starting Khala node as role '${NODE_ROLE}' with extra parachain args '${PARACHAIN_EXTRA_ARGS}' extra relaychain args '${RELAYCHAIN_EXTRA_ARGS}'"

/usr/local/bin/khala-node \
  --chain $PARACHAIN \
  --base-path $DATA_PATH \
  --database $PARACHAIN_DB \
  --name $NODE_NAME \
  --port $PARACHAIN_LIBP2P_PORT \
  --prometheus-port $PARACHAIN_PROMETHEUS_PORT \
  --rpc-port $PARACHAIN_RPC_PORT \
  --no-hardware-benchmarks \
  $PARACHAIN_EXPOSE_ENDPOINTS \
  $PARACHAIN_UNSAFE_RPC \
  $PARACHAIN_ROLE_ARGS \
  $PARACHAIN_EXTRA_ARGS \
  -- \
  --chain $RELAYCHAIN \
  --database $RELAYCHAIN_DB \
  --port $RELAYCHAIN_LIBP2P_PORT \
  --prometheus-port $RELAYCHAIN_PROMETHEUS_PORT \
  --rpc-port $RELAYCHAIN_RPC_PORT \
  --no-hardware-benchmarks \
  $RELAYCHAIN_EXPOSE_ENDPOINTS \
  $RELAYCHAIN_UNSAFE_RPC \
  $RELAYCHAIN_ROLE_ARGS \
  $RELAYCHAIN_EXTRA_ARGS

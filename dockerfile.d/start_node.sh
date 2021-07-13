#!/bin/bash

CHAIN="khala"
NODE_NAME="${NODE_NAME:-"khala-node"}"
NODE_ROLE="${NODE_ROLE:-""}"

case ${NODE_ROLE} in
  "")
    NODE_ROLE_ARGS=""
    ;;
  "FULL")
    NODE_ROLE_ARGS="--pruning archive --rpc-methods Unsafe"
    ;;
  "VALIDATOR")
    NODE_ROLE_ARGS="--collator --rpc-methods Unsafe"
    ;;
  *)
    echo "Unknown NODE_ROLE ${NODE_ROLE}"
    echo "accept values (case sensitive): <Empty> | FULL | VALIDATOR"
    exit 1
    ;;
esac

echo "Starting PhalaNode as role '${NODE_ROLE}' with extra opts '${EXTRA_OPTS}'"

./khala-node \
  --chain "${CHAIN}" \
  --base-path "${HOME}/data" \
  --name "${NODE_NAME}" \
  --port 30333 \
  --rpc-port 9933 \
  --ws-port 9944 \
  --ws-external \
  --prometheus-external \
  --rpc-external \
  --rpc-cors all \
  $NODE_ROLE_ARGS \
  $EXTRA_OPTS \
  -- \
  --port 30334
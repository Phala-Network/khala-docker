#!/bin/bash

TAG="${1:-latest}"

docker build -t "phalanetwork/khala-node:$TAG-vanilla" -f ./node-vanilla.Dockerfile .
docker build -t "phalanetwork/khala-node:$TAG-healthcheck" -f ./node-vanilla-healthcheck.Dockerfile .

docker build -t "phalanetwork/khala-dev-node:$TAG-vanilla" -f ./prebuilt_pt3_node-vanilla.Dockerfile .
docker build -t "phalanetwork/khala-dev-node:$TAG-healthcheck" -f ./prebuilt_pt3_node-vanilla-healthcheck.Dockerfile .

#!/bin/bash

TAG="${1:-latest}"

docker push "phalanetwork/khala-node:$TAG-vanilla"
docker push "phalanetwork/khala-node:$TAG-healthcheck"

docker push "phalanetwork/khala-dev-node:$TAG-vanilla"
docker push "phalanetwork/khala-dev-node:$TAG-healthcheck"

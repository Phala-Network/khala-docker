FROM ubuntu:20.04

ARG DEBIAN_FRONTEND='noninteractive'

WORKDIR /root

RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https software-properties-common readline-common curl vim wget gnupg gnupg2 gnupg-agent ca-certificates tini

ADD prebuilt/pt3/* .

ENV RUST_LOG="info"
ENV NODE_NAME='khala-dev-node'
ENV NODE_ROLE="MINER"

ENV PARACHAIN_EXTRA_ARGS=''
ENV RELAYCHAIN_EXTRA_ARGS=''

ENV PARACHAIN_BOOTNODE='/dns4/pc-test-3.phala.network/tcp/30333/ws/p2p/12D3KooWNVSZMd5Hh74h8icPdkRLRP3TCkwU89AMVjZEGmvQ86pq'
ENV RELAYCHAIN_BOOTNODE='/dns4/pc-test-3.phala.network/tcp/30334/ws/p2p/12D3KooWNcARLswVpKJsGK8v4krZNQQ3unbhxrZAk4YV5TX2rdos'

EXPOSE 9615
EXPOSE 9933
EXPOSE 9944
EXPOSE 30333
EXPOSE 9616
EXPOSE 9934
EXPOSE 9945
EXPOSE 30334

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/bin/bash", "./start_node.sh"]

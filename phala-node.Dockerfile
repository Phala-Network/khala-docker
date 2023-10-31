ARG NODE_BIN_IMAGE=""
FROM $NODE_BIN_IMAGE

WORKDIR /root

ADD dockerfile.d/start_node.sh ./start_node.sh

ENV RUST_LOG="info"
ENV NODE_NAME="phala-node"
ENV NODE_ROLE=""

ENV PARACHAIN="phala"
ENV RELAYCHAIN="polkadot"

ENV PARACHAIN_DB="rocksdb"
ENV RELAYCHAIN_DB="rocksdb"

ENV PARACHAIN_EXTRA_ARGS=""
ENV RELAYCHAIN_EXTRA_ARGS=""

EXPOSE 9615
EXPOSE 9616
EXPOSE 9944
EXPOSE 9945
EXPOSE 30333
EXPOSE 30334

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/bin/bash", "./start_node.sh"]

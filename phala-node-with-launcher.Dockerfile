ARG NODE_BIN_IMAGE=""
FROM $NODE_BIN_IMAGE

WORKDIR /root

ADD dockerfile.d/start_node_new.sh ./start_node.sh

ENV RUST_LOG="info"
ENV NODE_NAME="phala-node"
ENV NODE_ROLE=""

ENV PARACHAIN="phala"
ENV RELAYCHAIN="polkadot"

ENV PARACHAIN_DB="paritydb"
ENV RELAYCHAIN_DB="paritydb"

ENV PARACHAIN_LIBP2P_PORT="30333"
ENV RELAYCHAIN_LIBP2P_PORT="30334"

ENV PARACHAIN_PROMETHEUS_PORT="9615"
ENV RELAYCHAIN_PROMETHEUS_PORT="9616"

ENV PARACHAIN_HTTP_RPC_PORT="9933"
ENV RELAYCHAIN_HTTP_RPC_PORT="9934"

ENV PARACHAIN_WS_RPC_PORT="9944"
ENV RELAYCHAIN_WS_RPC_PORT="9945"

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

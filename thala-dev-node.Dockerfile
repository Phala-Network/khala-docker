FROM ubuntu:20.04 AS builder

ARG DEBIAN_FRONTEND='noninteractive'
ARG RUST_TOOLCHAIN='nightly-2022-07-11'
ARG PHALA_GIT_REPO='https://github.com/Phala-Network/khala-parachain.git'
ARG PHALA_GIT_TAG='main'
ARG POLKADOT_VERSION="v0.9.26"

WORKDIR /root

RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https software-properties-common readline-common \
    curl vim wget gnupg gnupg2 gnupg-agent ca-certificates cmake pkg-config libssl-dev git \
    build-essential llvm clang libclang-dev protobuf-compiler

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain="${RUST_TOOLCHAIN}" && \
    $HOME/.cargo/bin/rustup target add wasm32-unknown-unknown --toolchain "${RUST_TOOLCHAIN}"

RUN echo "Compiling Khala from $PHALA_GIT_REPO:$PHALA_GIT_TAG..." && \
    git clone --depth 1 --recurse-submodules --shallow-submodules -j 8 -b ${PHALA_GIT_TAG} ${PHALA_GIT_REPO} khala-parachain && \
    cd khala-parachain && \
    PATH="$HOME/.cargo/bin:$PATH" cargo build --profile production && \
    cp ./target/production/khala-node ./polkadot-launch/bin/ && \
    cp -r ./polkadot-launch /root && \
    PATH="$HOME/.cargo/bin:$PATH" cargo clean && \
    rm -rf /root/.cargo/registry && \
    rm -rf /root/.cargo/git

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    cd /root/polkadot-launch && \
    npm install && npm run build

RUN curl -fsSL https://github.com/paritytech/polkadot/releases/download/$POLKADOT_VERSION/polkadot \
    -o /root/polkadot-launch/bin/polkadot && \
    chmod +x /root/polkadot-launch/bin/polkadot

# ====

FROM node:18.6-bullseye-slim

COPY --from=builder /root/polkadot-launch /srv/polkadot-launch

EXPOSE 9615
EXPOSE 9616
EXPOSE 9933
EXPOSE 9934
EXPOSE 9944
EXPOSE 9945
EXPOSE 30333
EXPOSE 30334

WORKDIR /srv/polkadot-launch

CMD ["node", "dist/cli.js", "./thala_dev.config.json"]
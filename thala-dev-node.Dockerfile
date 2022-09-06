FROM ubuntu:20.04 AS builder

ARG DEBIAN_FRONTEND='noninteractive'
ARG RUST_TOOLCHAIN='nightly-2022-07-11'
ARG PHALA_GIT_REPO='https://github.com/Phala-Network/khala-parachain.git'
ARG PHALA_GIT_TAG='main'
ARG POLKADOT_GIT_REPO='https://github.com/paritytech/polkadot.git'
ARG POLKADOT_GIT_TAG='v0.9.28'
# ARG POLKADOT_VERSION="v0.9.26"

WORKDIR /root

RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https software-properties-common readline-common \
    curl vim wget gnupg gnupg2 gnupg-agent ca-certificates cmake pkg-config libssl-dev git \
    build-essential llvm clang libclang-dev xz-utils && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain="${RUST_TOOLCHAIN}" && \
    $HOME/.cargo/bin/rustup target add wasm32-unknown-unknown --toolchain "${RUST_TOOLCHAIN}" && \
    curl -Ls https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz -o - | tar xvJf - -C /tmp && \
    cp /tmp/upx-3.96-amd64_linux/upx /usr/local/bin/ && \
    chmod +x /usr/local/bin/upx && \
    apt-get remove -y xz-utils && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Compiling Polkadot from $POLKADOT_GIT_REPO:$POLKADOT_GIT_TAG..." && \
    git clone --depth 1 --recurse-submodules --shallow-submodules -j 8 -b ${POLKADOT_GIT_TAG} ${POLKADOT_GIT_REPO} polkadot && \
    cd polkadot && \
    PATH="$HOME/.cargo/bin:$PATH" RUSTFLAGS="-C opt-level=z -C link-args=-s" cargo build --profile production && \
    mkdir /root/bin && cp /root/polkadot/target/production/polkadot /root/bin/ && \
    PATH="$HOME/.cargo/bin:$PATH" cargo clean

RUN echo "Compiling Khala from $PHALA_GIT_REPO:$PHALA_GIT_TAG..." && \
    git clone --depth 1 --recurse-submodules --shallow-submodules -j 8 -b ${PHALA_GIT_TAG} ${PHALA_GIT_REPO} khala-parachain && \
    cd khala-parachain && \
    PATH="$HOME/.cargo/bin:$PATH" RUSTFLAGS="-C opt-level=z -C link-args=-s" cargo build --profile production && \
    cp ./target/production/khala-node ./polkadot-launch/bin/ && \
    PATH="$HOME/.cargo/bin:$PATH" cargo clean && \
    cp -r ./polkadot-launch /root

RUN rm -rf /root/.cargo/registry && \
    rm -rf /root/.cargo/git && \
    mv /root/bin/polkadot /root/polkadot-launch/bin/

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    cd /root/polkadot-launch && \
    npm install && npm run build

RUN cd /root/polkadot-launch/bin && \
    upx --best --lzma -qq khala-node && \
    upx --best --lzma -qq polkadot

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
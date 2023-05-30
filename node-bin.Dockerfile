FROM ubuntu:22.04 AS builder

ARG RUST_TOOLCHAIN='stable'
ARG CARGO_PROFILE='production'
ARG PHALA_GIT_REPO='https://github.com/Phala-Network/khala-parachain.git'
ARG PHALA_GIT_TAG='main'

WORKDIR /root

RUN apt-get update && \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y apt-utils apt-transport-https software-properties-common readline-common curl vim wget gnupg gnupg2 gnupg-agent ca-certificates cmake pkg-config libssl-dev git build-essential llvm clang libclang-dev rsync libboost-all-dev libssl-dev zlib1g-dev miniupnpc protobuf-compiler

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain="${RUST_TOOLCHAIN}" && \
    $HOME/.cargo/bin/rustup target add wasm32-unknown-unknown --toolchain "${RUST_TOOLCHAIN}"

RUN echo "Compiling Khala from $PHALA_GIT_REPO:$PHALA_GIT_TAG..." && \
    git clone --depth 1 --recurse-submodules --shallow-submodules -j 8 -b ${PHALA_GIT_TAG} ${PHALA_GIT_REPO} khala-parachain && \
    cd khala-parachain && \
    PATH="$HOME/.cargo/bin:$PATH" cargo build --profile $CARGO_PROFILE && \
    cp ./target/production/khala-node /root && \
    PATH="$HOME/.cargo/bin:$PATH" cargo clean && \
    rm -rf /root/.cargo/registry && \
    rm -rf /root/.cargo/git

# ====

FROM ubuntu:22.04

WORKDIR /root

RUN apt-get update && \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y apt-utils apt-transport-https software-properties-common readline-common curl vim wget gnupg gnupg2 gnupg-agent ca-certificates tini

COPY --from=builder /root/khala-node /usr/local/bin

ENV RUST_LOG="info"

EXPOSE 9615 9616
EXPOSE 9933 9934
EXPOSE 9944 9945
EXPOSE 30333 30334

VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/khala-node"]

FROM phalanetwork/khala-dev-node

ENTRYPOINT [ "/root/khala-node" ]
CMD [ ]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*
COPY ./dockerfile.d/console.js ./dockerfile.d/health.sh /root/

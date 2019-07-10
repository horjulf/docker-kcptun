FROM alpine:3.10

ARG KCPTUN_VERSION

LABEL KCPTUN_VERSION=${KCPTUN_VERSION}

RUN cd /tmp && \
    echo "Download version: ${KCPTUN_VERSION}" && \
    wget -q "https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz" && \
    tar zxf "kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz" && \
    mv client_linux_amd64 /bin/client && \
    mv server_linux_amd64 /bin/server && \
    rm -rf /tmp/*

ARG KCPTUN_BRANCH="master"

# Build
FROM golang:1.15-alpine3.12 as builder

ARG KCPTUN_BRANCH
ENV KCPTUN_BRANCH=${KCPTUN_BRANCH}

# Upgrade and install dependencies
RUN apk upgrade -U \
  && apk add git gcc libc-dev linux-headers

# Build
RUN cd \
  # Clone
  && git clone --depth=1 -b "${KCPTUN_BRANCH}" https://github.com/horjulf/kcptun.git \
  && cd kcptun \
  # Vars
  && KCPTUN_GIT=$(git rev-parse --short HEAD) \
  && DATE=$(date -u +%Y%m%d) \
  # Vendor
  && go mod vendor \
  # Build
  && cd client && go build -trimpath -ldflags "-s -w -X main.VERSION=${KCPTUN_GIT}-${DATE}" -o /go/bin/ . && cd .. \
  && cd server && go build -trimpath -ldflags "-s -w -X main.VERSION=${KCPTUN_GIT}-${DATE}" -o /go/bin/ . && cd ..

# Runtime
FROM alpine:3.12

ARG KCPTUN_BRANCH
ENV KCPTUN_BRANCH=${KCPTUN_BRANCH}

LABEL KCPTUN_BRANCH=${KCPTUN_BRANCH}

RUN apk upgrade -U --no-cache \
  && apk add -U --no-cache iptables

COPY --from=builder /go/bin/ /bin

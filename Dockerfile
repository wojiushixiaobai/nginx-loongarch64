FROM debian:buster-slim as builder
WORKDIR /opt
ARG NGINX_VERSION=1.24.0

ARG BUILD_DEPENDENCIES="         \
        ca-certificates          \
        curl                     \
        devscripts               \
        lsb-release              \
        make                     \
        mercurial                \
        quilt                    \
        xsltproc                 \
        zlib1g-dev"

ARG DEPENDENCIES="               \
        libedit-dev              \
        libgeoip-dev             \
        libgd-dev                \
        libparse-recdescent-perl \
        libpcre2-dev             \
        libperl-dev              \
        libssl-dev               \
        libxml2-utils            \
        libxslt1-dev"

ARG DEBIAN_FRONTEND=noninteractive
RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPENDENCIES \
    && apt-get install -y --no-install-recommends $DEPENDENCIES \
    && echo "no" | dpkg-reconfigure dash \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && hg clone -b stable-${NGINX_VERSION%.*} http://hg.nginx.org/pkg-oss

RUN set -ex \
    && cd /opt/pkg-oss/debian
    && make all

RUN set -ex \
    && rm -rf /opt/pkg-oss

FROM debian:buster-slim

WORKDIR /opt/nginx

COPY --from=builder /opt /opt/nginx/dist

VOLUME /dist

CMD cp -rf dist/* /dist/
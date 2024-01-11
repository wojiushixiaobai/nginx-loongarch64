FROM debian:buster-slim as builder
WORKDIR /opt
ARG VERSION=1.24.0

ARG BUILD_DEPENDENCIES="         \
        ca-certificates          \
        cmake                    \
        curl                     \
        devscripts               \
        equivs                   \
        git                      \
        libxml2-utils            \
        lsb-release              \
        make                     \
        mercurial                \
        xsltproc"

ARG DEBIAN_FRONTEND=noninteractive
RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPENDENCIES \
    && echo "no" | dpkg-reconfigure dash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && apt-get update \
    && hg clone -u ${VERSION}-1 http://hg.nginx.org/pkg-oss \
    && cp -R /opt/pkg-oss /opt/nginx-build \
    && cd /opt/nginx-build/debian \
    && make rules \
    && \
    for f in debuild-module-*/nginx-${VERSION}/debian/control; do \
        mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i ${f}; \
    done \
    && cd /opt \
    && rm -rf /opt/nginx-build \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/pkg-oss

RUN set -ex \
    && cd debian \
    && make all

RUN set -ex \
    && rm -rf /opt/pkg-oss

FROM debian:buster-slim

WORKDIR /opt/nginx

COPY --from=builder /opt /opt/nginx/dist

VOLUME /dist

CMD cp -rf dist/* /dist/
# syntax=docker/dockerfile:experimental

FROM alpine:3.19

LABEL maintainer="cmahnke@gmail.com"
LABEL org.opencontainers.image.source https://github.com/cmahnke/font-action

ARG GIT_TAG=""

ENV BUILD_DEPS="cmake g++ clang-dev make" \
#libc-dev util-linux-dev libxml2-dev binutils harfbuzz pkgconfig zlib-dev libffi-dev libgit2-dev
    RUN_DEPS="busybox git libgcc libstdc++" \
#libuuid cairo freetype libxml2 libimagequant pngquant zlib libffi
    BUILD_DIR=/tmp/build \
    BUILD_CONTEXT=/mnt/build-context \
    WOFF2_GIT_URL="https://github.com/google/woff2.git" \
    DEFAULT_GIT_TAG="v1.0.2" \
    CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN --mount=target=/mnt/build-context \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    #echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
    mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    if [ -z "$GIT_TAG" ] ; then \
        GIT_TAG=$DEFAULT_GIT_TAG ; \
    fi && \
    git config --global advice.detachedHead false && \
    git clone --depth 1 --recursive --branch "$GIT_TAG" --shallow-submodules $WOFF2_GIT_URL && \
    cd woff2 && \
    make clean all && \
    mv woff2_compress woff2_decompress woff2_info /usr/local/bin && \
    cd .. && \
# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache

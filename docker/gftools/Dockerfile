# syntax=docker/dockerfile:experimental

FROM python:3.11-alpine

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions font conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert Font from and to various formats"
LABEL org.opencontainers.image.source https://github.com/cmahnke/font-action

ARG GIT_TAG=""

ENV BUILD_DEPS="cmake g++ clang-dev make libc-dev util-linux-dev libxml2-dev binutils harfbuzz pkgconfig maturin libimagequant-dev rust cargo zlib-dev libffi-dev libgit2-dev pkgconf-dev cairo-dev" \
    RUN_DEPS="busybox git libgcc libstdc++ libuuid cairo freetype libxml2 libimagequant pngquant zlib libffi pkgconf bash curl cairo" \
    BUILD_DIR=/tmp/build \
    BUILD_CONTEXT=/mnt/build-context \
    WOFF2_GIT_URL="https://github.com/google/woff2.git" \
    DEFAULT_GIT_TAG="v1.0.2" \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    CMAKE_POLICY_VERSION_MINIMUM=3.5

RUN --mount=target=/mnt/build-context \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    #echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
    mkdir -p $BUILD_DIR ~/.config/pip/ && \
    printf "\n[global]\nbreak-system-packages = true" >> ~/.config/pip/pip.conf && \
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
    #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/googlefonts/gftools/main/bin/install_rust_binaries.sh)" && \
    pip3 install --upgrade pip setuptools wheel && \
    pip3 install 'gftools[qa]' && \
# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache

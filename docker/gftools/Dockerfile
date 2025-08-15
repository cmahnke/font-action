# syntax=docker/dockerfile:experimental

#FROM alpine:3.21
FROM python:3.11-alpine

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions font conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert Font from and to various formats"
LABEL org.opencontainers.image.source https://github.com/cmahnke/font-action

ARG GIT_TAG="" \
    NO_REQUIREMENTS=true

ENV BUILD_DEPS="cmake g++ clang-dev make libc-dev util-linux-dev libxml2-dev binutils harfbuzz pkgconfig maturin libimagequant-dev rust cargo zlib-dev libffi-dev libgit2-dev pkgconf-dev" \
    RUN_DEPS="busybox git libgcc libstdc++ libuuid cairo freetype libxml2 libimagequant pngquant zlib libffi pkgconf" \
# python3-dev py3-maturin py3-pip py3-gitpython py3-numpy py3-cairo py3-cffsubr py3-yaml py3-pygments py3-pygit2 py3-cffi py3-zopfli py3-pillow py3-brotli py3-wheel py3-beautifulsoup4 py3-certifi py3-urllib3 py3-lxml py3-ufolib2 py3-skia-pathops py3-psutil py3-compreffor py3-simplejson py3-defcon py3-fontmath py3-fontforge py3-fonttools py3-rich py3-wrapt py3-commonmark py3-unidecode py3-jinja2 py3-requests py3-regex py3-protobuf py3-tabulate py3-toml py3-dateutil py3-colorlog py3-cu2qu py3-jwt py3-deprecated py3-parsing py3-packaging py3-olefile py3-dateutil py3-simplejson py3-six py3-tz py3-cparser py3-click
# Ommited, since these are problematic during dependency resolution
# py3-cattrs py3-statmake py3-rstr py3-bump2version
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
    cp /mnt/build-context/requirements.txt . && \
    #pip3 install --upgrade setuptools && \
    pip install --upgrade pip && \
    #pip install "cython<3.0.0" wheel && \
    #pip install "pyyaml<=5.4.1" --no-build-isolation && \
    if [ "$NO_REQUIREMENTS" = 'true' ] ; then \
      pip3 install 'gftools[qa]' ; \
    else \
      pip3 install -r requirements.txt ; \
    fi && \
    pip3 install -r requirements.txt && \
# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache

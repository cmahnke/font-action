# syntax=docker/dockerfile:experimental

FROM alpine:3.17.0

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions font conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert Font from and to variuos formats"
LABEL org.opencontainers.image.source https://github.com/cmahnke/font-action

ARG GIT_TAG=""

ENV BUILD_DEPS="cmake git g++ clang-dev make libc-dev libgcc binutils harfbuzz pkgconfig py3-pip python3-dev libffi-dev rust cargo" \
    RUN_DEPS="busybox libstdc++ cairo freetype libffi py3-gitpython py3-numpy py3-cairo py3-cffsubr py3-yaml py3-pygments py3-pygit2 py3-cffi py3-zopfli py3-pillow py3-brotli py3-wheel py3-beautifulsoup4 py3-certifi py3-urllib3 py3-lxml py3-ufolib2 py3-skia-pathops py3-psutil py3-compreffor py3-simplejson py3-defcon py3-fontmath py3-rich py3-wrapt py3-commonmark py3-unidecode py3-jinja2 py3-maturin" \
    BUILD_DIR=/tmp/build \
    WOFF2_GIT_URL="https://github.com/google/woff2.git" \
    DEFAULT_GIT_TAG="v1.0.2"

RUN apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
    mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    if [ -z "$GIT_TAG" ] ; then \
        GIT_TAG=$DEFAULT_GIT_TAG ; \
    fi && \
    git clone --depth 1 --recursive --branch "$GIT_TAG" --shallow-submodules $WOFF2_GIT_URL && \
    cd woff2 && \
    make clean all && \
    mv woff2_compress woff2_decompress woff2_info /usr/local/bin && \
    pip3 install 'gftools[qa]' && \

# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache /usr/bin/benchmark_xl

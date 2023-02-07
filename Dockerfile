# syntax=docker/dockerfile:experimental

FROM alpine:3.17.0

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions font conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert Font from and to variuos formats"
LABEL org.opencontainers.image.source https://github.com/cmahnke/font-action

ARG GIT_TAG=""

ENV BUILD_DEPS="cmake g++ clang-dev make libc-dev binutils harfbuzz pkgconfig py3-pip py3-maturin maturin libimagequant-dev python3-dev rust cargo zlib-dev libffi-dev" \
    RUN_DEPS="busybox git libgcc libstdc++ cairo freetype libimagequant pngquant zlib libffi py3-gitpython py3-numpy py3-cairo py3-cffsubr py3-yaml py3-pygments py3-pygit2 py3-cffi py3-zopfli py3-pillow py3-brotli py3-wheel py3-beautifulsoup4 py3-certifi py3-urllib3 py3-lxml py3-ufolib2 py3-skia-pathops py3-psutil py3-compreffor py3-simplejson py3-defcon py3-fontmath py3-rich py3-wrapt py3-commonmark py3-unidecode py3-jinja2 py3-requests py3-regex py3-statmake py3-protobuf py3-tabulate py3-toml py3-dateutil py3-colorlog py3-click py3-cu2qu py3-jwt py3-cattrs py3-rstr py3-bump2version py3-deprecated" \
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
    pip3 install 'gftools[qa]' && \
#    pip3 install --no-deps -r $BUILD_CONTEXT/requirements.txt && \
#    pip3 install pngquant pngquant_cli --force-reinstall --ignore-installed --no-binary pngquant_cli && \
#    pip3 install --no-deps 'gftools[qa]' && \

# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache

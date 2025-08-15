# syntax=docker/dockerfile:experimental

FROM maven:3-eclipse-temurin-21 AS builder

ARG LIBGDX_TAG=1.13.5
ARG ANDROID_SDK_VERSION=10406996

ENV BUILD_DEPS="git wget unzip" \
    BUILD_DIR=/tmp/build \
    LIBGDX_GIT_URL=https://github.com/libgdx/libgdx.git \
    LIBGDX_DIR=/opt/libgdx \
    GRADLE_VERSION=8.14.3 \
    GRADLE_HOME=/opt/gradle \
    ANDROID_HOME=/opt/android-sdk

RUN mkdir -p $BUILD_DIR $LIBGDX_DIR $ANDROID_HOME && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y $BUILD_DEPS && \
    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
# Install Android SDK
    cd $ANDROID_HOME && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip && \
# Accept licence for platforms;android-33 and build-tools;33.0.2
    yes | ./cmdline-tools/bin/sdkmanager --licenses --sdk_root=$ANDROID_HOME && \
# Install LibGDX
    cd $BUILD_DIR && \
    git clone $LIBGDX_GIT_URL --branch $LIBGDX_TAG --single-branch libgdx && \
    cd libgdx && \
    chmod +x gradlew && \
    ./gradlew --no-watch-fs fetchNatives --info -x test && \
    ./gradlew --no-watch-fs clean distHiero --info -x test && \
    cp extensions/gdx-tools/build/libs/runnable-hiero.jar $LIBGDX_DIR/

FROM alpine:3.22

LABEL maintainer="cmahnke@gmail.com"
LABEL org.opencontainers.image.source https://github.com/cmahnke/font-action

ENV RUN_DEPS="temurin-21-jre" \
    BUILD_DIR=/tmp/build \
    LIBGDX_DIR=/opt/libgdx

COPY --from=builder $LIBGDX_DIR/runnable-hiero.jar $LIBGDX_DIR/

RUN wget -O /etc/apk/keys/adoptium.rsa.pub https://packages.adoptium.net/artifactory/api/security/keypair/public/repositories/apk && \
    mkdir -p /etc/apk && \
    echo 'https://packages.adoptium.net/artifactory/apk/alpine/main' >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community" >> /etc/apk/repositories && \
    apk --update upgrade && \
    apk add --no-cache $BUILD_DEPS $RUN_DEPS && \
    mkdir -p $LIBGDX_DIR && \
# Cleanup
    cd / && rm -rf $BUILD_DIR && \
    apk del $BUILD_DEPS && \
    rm -rf /var/cache/apk/*

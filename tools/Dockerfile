# Copyright 2021 Nokia
# Licensed under the Apache License 2.0
# SPDX-License-Identifier: Apache-2.0

ARG build_env="no_proxy"

#FROM openjdk:17-slim-bullseye as build_no_proxy
FROM openjdk:8-jdk-slim as build_no_proxy
ONBUILD RUN echo "I don't copy proxy settings"

FROM openjdk:8-jdk-slim as build_proxy
ONBUILD COPY proxy.conf /etc/apt/apt.conf.d/proxy.conf

################ Add all non proxy dependent stuff here
FROM build_${build_env}
ARG DEBIAN_FRONTEND=noninteractive
COPY c2m.sh ./c2m.sh
COPY c2m-wrapper.sh ./c2m-wrapper.sh

# Install wget
RUN apt-get update && apt-get -y install apt-utils
RUN apt-get -y install wget pandoc

RUN wget -q https://repo1.maven.org/maven2/de/viaboxx/markdown/confluence2md/2.1/confluence2md-2.1-fat.jar

#!/bin/bash

# Copyright 2021 Nokia
# Licensed under the Apache License 2.0
# SPDX-License-Identifier: Apache-2.0

# Build script to create c2m container.

set -x

build_env="no_proxy"
proxy=""
if [[ -z "${http_proxy}" ]]; then
    echo "http_proxy is empty"
else
    echo "http_proxy is set to $http_proxy"
    build_env="proxy"
    if [[ $http_proxy =~ ^http:\/\/[0-9] ]]; then
        echo "starts with http"
        proxy=$http_proxy
    elif [[ $http_proxy =~ ^[0-9] ]]; then
        echo "starts with number"
        proxy=http://$http_proxy
    fi
    echo "Acquire::http::Proxy \"${proxy}\";" > proxy.conf
fi

echo "Proxy set to $proxy, build env is $build_env."

docker build --no-cache --build-arg http_proxy=$proxy --build-arg https_proxy=$proxy --build-arg build_env=$build_env -t c2m:latest -t c2m:`git log -1 --format=%h` . || echo "Build failed."

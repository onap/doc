#!/bin/bash
#
# Copyright 2021 Nokia
# Licensed under the Apache License 2.0
# SPDX-License-Identifier: Apache-2.0

set -x
echo "run-c2m -------------------------------------------------------------"
if [[ -z "$CONFLUENCE_USERNAME" || -z "$CONFLUENCE_PASSWORD" ]]
then
    echo "Mandatory environment variables:"
    echo "  CONFLUENCE_USERNAME: Confluence username"
    echo "  CONFLUENCE_PASSWORD: Confluence password."
    echo "Be aware! Setting bash debuging on will print credentials."
    exit
fi

proxy=""
if [[ -z "${http_proxy}" ]]; then
    echo "http_proxy is empty"
else
    echo "http_proxy is set to $http_proxy"
    if [[ $http_proxy =~ ^http:\/\/[0-9] ]]; then
        echo "starts with http"
        proxy=$http_proxy
    elif [[ $http_proxy =~ ^[0-9] ]]; then
        echo "starts with number"
        proxy=http://$http_proxy
    fi
fi

echo "Proxy set to $proxy, build env is $build_env."

docker run -e http_proxy=$proxy -e https_proxy=$proxy -e HTTP_PROXY=$proxy -e HTTPS_PROXY=$proxy -e CONFLUENCE_PASSWORD=$CONFLUENCE_PASSWORD -e CONFLUENCE_USERNAME=$CONFLUENCE_USERNAME -v $PWD:/mount c2m:latest ./c2m-wrapper.sh /mount/$1
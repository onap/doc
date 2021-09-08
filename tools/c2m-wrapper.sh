#!/bin/bash
#
# Copyright 2021 Nokia
# Licensed under the Apache License 2.0
# SPDX-License-Identifier: Apache-2.0
set -x
echo "c2m-wrapper -------------------------------------------------------------"

rst_editor="ls " ./c2m.sh $1

out_dir="/mount/output"
[ ! -d $out_dir ] && mkdir $out_dir
[ -d $out_dir ] && rm -rf $out_dir/*

mv -f -v output/* $out_dir
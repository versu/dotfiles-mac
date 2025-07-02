#!/bin/bash

source "$(dirname "$0")/common.sh"

cd "$CUR_DIR"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# delete install files
rm -rf ./awscli-exe-linux-x86_64.zip
rm -rf ./aws

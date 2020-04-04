#!/bin/bash

# Install packages
sudo yum update
sudo yum install jq moreutils -y

# Upgrade pip
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm get-pip.py

# Install awscli
install awscli --upgrade --user

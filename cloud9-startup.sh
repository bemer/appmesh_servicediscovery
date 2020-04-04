#!/bin/bash

# Install packages
sudo yum update
sudo yum install jq moreutils -y

# Upgrade pip
sudo pip3 install --upgrade pip
echo "export PATH=~/.local/bin:$PATH" >> ~/.bash_profile
source ~/.bash_profile

# Install awscli
pip3 install awscli --upgrade --user
souce ~/.bash_profile
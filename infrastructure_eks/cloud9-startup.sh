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
source ~/.bash_profile

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.19.0-rc.0/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
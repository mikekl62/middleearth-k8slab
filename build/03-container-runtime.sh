#!/bin/bash

################################################################################
# Installation of container runtime
#
# To be executed on master and all worker nodes
#
# References:
# https://github.com/piyushsachdeva/CKA-2024/blob/main/Resources/Day27/readme.md
#
################################################################################

CONTAINERD_VERSION=2.2.3
RUNC_VERSION=1.4.2
CNI_PLUGINS_VERSION=1.9.1

########################
# 1 - Install containerd
########################

# Download and expand containerd archive
curl -LO https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
rm -f containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz

# Download and install containerd service file
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system/
sudo mv containerd.service /usr/local/lib/systemd/system/

# Create containerd config, activate SystemdCgroup
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Start containerd service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

# Check that containerd service is up and running
systemctl status containerd

##################
# 2 - Install runc
##################

curl -LO https://github.com/opencontainers/runc/releases/download/v$RUNC_VERSION/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
rm -f runc.amd64

#########################
# 3 - Install CNI plugins
#########################

curl -LO https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGINS_VERSION/cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz
rm -f cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz

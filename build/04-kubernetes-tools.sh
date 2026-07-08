#!/bin/bash

########################################################################################
# Installation of kubernetes tools
#
# To be executed on master and all worker nodes
#
# References:
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm
# https://github.com/piyushsachdeva/CKA-2024/blob/main/Resources/Day27/readme.md
#
#######################################################################################

KUBE_MINOR_VER=1.36
KUBE_PATCH_VER=1.36.0
KUBE_PKG_VER=1.36.0-1.1

##########################################
# 1 - Install kubeadm, kubelet and kubectl
##########################################

# Install supporting packages
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Install APT keyring
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBE_MINOR_VER/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
    https://pkgs.k8s.io/core:/stable:/v$KUBE_MINOR_VER/deb/ /" | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubernetes tools
sudo apt-get update
sudo apt-get install -y kubelet=$KUBE_PKG_VER \
                        kubeadm=$KUBE_PKG_VER \
                        kubectl=$KUBE_PKG_VER \
                        --allow-downgrades \
                        --allow-change-held-packages
sudo apt-mark hold kubelet kubeadm kubectl

# Check versions
kubeadm version
kubelet --version
kubectl version --client

##############################################
# 2 - Configure crictl to work with containerd
##############################################

sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock

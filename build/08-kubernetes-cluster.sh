#!/bin/bash

##############################################################################################
# Create a cluster
#
# References:
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm
# https://github.com/piyushsachdeva/CKA-2024/blob/main/Resources/Day27/readme.md
#
##############################################################################################

POD_NETWORK_ADDR=10.244.0.0
POD_NETWORK_MASK=22
POD_NETWORK_CIDR=$POD_NETWORK_ADDR/$POD_NETWORK_MASK
CALICO_VERSION=3.32.0

# On master (me004k8sm)

##################################
# 1 - Bootstrap kubernetes cluster
##################################

sudo kubeadm init --pod-network-cidr=$POD_NETWORK_CIDR

##################################################
# 2 - Save information needed for the worker joins
##################################################

JOIN_CMD=$(kubeadm token create --print-join-command)
MASTER=$(echo $JOIN_CMD | cut -d' ' -f3)
JOIN_TOKEN=$(echo $JOIN_CMD | cut -d' ' -f5)
CERT_HASH=$(echo $JOIN_CMD | cut -d' ' -f7)

########################################
# 3 - Copy kube config to home directory
########################################

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
chmod 600 $HOME/.kube/config

###############################
# 4 - Install calico networking
###############################

# Create tigera operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/tigera-operator.yaml

# Download calico custom resources manifest
curl https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/custom-resources.yaml -O

# Set ip pool cidr, should be the same as the pod network cidr
sed -Ei "s/\s+cidr: .+/        cidr: $POD_NETWORK_ADDR\/$POD_NETWORK_MASK/" ./custom-resources.yaml

# Apply the manifest
kubectl apply -f custom-resources.yaml

# On worker nodes

############################
# 5 - Join worker to cluster
############################

sudo kubeadm join $MASTER --token $JOIN_TOKEN --discovery-token-ca-cert-hash $CERT_HASH

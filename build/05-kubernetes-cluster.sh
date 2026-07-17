#!/bin/bash

##############################################################################################
# Create a cluster
#
# References:
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm
# https://github.com/piyushsachdeva/CKA-2024/blob/main/Resources/Day27/readme.md
#
##############################################################################################

CLUSTER_OLD_NAME=kubernetes
CLUSTER_NEW_NAME=middleearth-k8slab
KUBEADM_CONFIG=~/kubeadm-config.yaml
MASTER_NODE_ADDR=192.168.2.110
MASTER_NODE_NAME=me004k8sm
POD_NETWORK_ADDR=10.244.0.0
POD_NETWORK_MASK=22
POD_NETWORK_CIDR=$POD_NETWORK_ADDR/$POD_NETWORK_MASK
CALICO_VERSION=3.32.0

# On master (me004k8sm)

################################
# 1 - Create default init config
################################

sudo kubeadm config print init-defaults > $KUBEADM_CONFIG

######################
# 2 - Customize config
######################

sed -iE -e "s/clusterName: $CLUSTER_OLD_NAME$/clusterName: $CLUSTER_NEW_NAME/" \
        -e "/networking:/a\  podSubnet: $POD_NETWORK_CIDR" \
        -e "s/advertiseAddress: 1.2.3.4$/advertiseAddress: $MASTER_NODE_ADDR/" \
        -e "s/name: node$/name: $MASTER_NODE_NAME/" \
        $KUBEADM_CONFIG

##################################
# 3 - Bootstrap kubernetes cluster
##################################

sudo kubeadm init --config $KUBEADM_CONFIG

########################################
# 4 - Copy kube config to home directory
########################################

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
chmod 600 $HOME/.kube/config

#################################################
# 5 - Save information needed for joining workers
#################################################

JOIN_CMD=$(kubeadm token create --print-join-command)
MASTER=$(echo $JOIN_CMD | cut -d' ' -f3)
JOIN_TOKEN=$(echo $JOIN_CMD | cut -d' ' -f5)
CERT_HASH=$(echo $JOIN_CMD | cut -d' ' -f7)

###############################
# 6 - Install calico networking
###############################

# Create tigera operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/tigera-operator.yaml

# Download calico custom resources manifest
curl https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/custom-resources.yaml -O

# Set ip pool cidr, should be the same as the pod network cidr
sed -Ei "s/\s+cidr: .+/        cidr: $POD_NETWORK_ADDR\/$POD_NETWORK_MASK/" ./custom-resources.yaml

# Apply the manifest
kubectl apply -f custom-resources.yaml

# Clean up
rm -f custom-resources.yaml

# On worker nodes

############################
# 7 - Join worker to cluster
############################

sudo kubeadm join $MASTER --token $JOIN_TOKEN --discovery-token-ca-cert-hash $CERT_HASH

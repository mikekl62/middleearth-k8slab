#!/bin/bash

####################################################################
# Cluster rename
# 
# When the lab cluster was bootstrapped no custom cluster name was
# provided, which means that the default name 'kubernetes' was used. 
# Renaming of the lab cluster from the default name 'kubernetes'
# to 'middleearth-k8slab'.
#
# Beware that renaming existing clusters is not straight forward
# and it should be avoided. Manual editing of kubeadmin config and
# context is needed.
#
# To be executed on master node.
###################################################################

ADMIN_USER=kubernetes-admin
CLUSTER_OLD_NAME=kubernetes
CLUSTER_NEW_NAME=middleearth-k8slab
KUBE_CONFIG=/etc/kubernetes/admin.conf
KUBEADM_CONFIG=~/kubeadm-init-config.yaml

########################
# 1 - Rename the cluster
########################

# Save init defaults to a file
# sudo kubeadm config print init-defaults > $KUBEADM_CONFIG
kubectl get configmaps -n kube-system kubeadm-config -o yaml > $KUBEADM_CONFIG

# Edit the kubeadm config, replace the old name with the new
# DO NOT anchor the regexp to the beginning of the line, it will break YAML indentation
sed -iE "s/clusterName: $CLUSTER_OLD_NAME$/clusterName: $CLUSTER_NEW_NAME/" $KUBEADM_CONFIG

# Trigger an init of the controller-manager pod, this regenerates the manifest 
sudo kubeadm init phase control-plane controller-manager --config $KUBEADM_CONFIG

# Clean up
rm $KUBEADM_CONFIG

#########################################
# 2 - Update the kubernetes configuration
#########################################

# Replace all references to 'kubernetes' cluster with 'middleearth-k8slab'.
# DO NOT anchor the regexp to the beginning of the line, it will break YAML indentation
sudo sed -iE -e "s/name: $CLUSTER_OLD_NAME$/name: $CLUSTER_NEW_NAME/" \
             -e "s/cluster: $CLUSTER_OLD_NAME$/cluster: $CLUSTER_NEW_NAME/" \
             -e "s/name: $ADMIN_USER@$CLUSTER_OLD_NAME$/name: $ADMIN_USER@$CLUSTER_NEW_NAME/" \
             -e "s/current-context: $ADMIN_USER@$CLUSTER_OLD_NAME$/current-context: $ADMIN_USER@$CLUSTER_NEW_NAME/" \
             $KUBE_CONFIG

################################################
# 3 - Copy the new kube config to home directory
################################################

cp $HOME/.kube/config $HOME/.kube/config-$(date +%Y%m%d-%H%M%S).backup
sudo cp -f $KUBE_CONFIG $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
chmod 600 $HOME/.kube/config

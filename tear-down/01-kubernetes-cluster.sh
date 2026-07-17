#!/bin/bash

##############################################################################################
# Delete a cluster 
#
# References:
# https://k8s.io/docs/reference/setup-tools/kubeadm/kubeadm-reset
#
##############################################################################################

WORKER_NODE=me004k8sw01

# On each worker node

#######################
# 1 - Reset worker node
#######################

sudo kubeadm reset

# On master

########################
# 2 - Delete worker node
########################

kubectl delete node $WORKER_NODE

#########################
# 3 - Reset control plane
#########################

sudo kubeadm reset

###############################
# 4 - Remaining manual clean up
###############################

# T B D
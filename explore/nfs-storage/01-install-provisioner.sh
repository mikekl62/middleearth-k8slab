#!/bin/bash

DRIVER_VERSION="v4.13.4"

# Install NFS CSI Driver
curl -skSL \
     https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/$DRIVER_VERSION/deploy/install-driver.sh | \
     bash -s $DRIVER_VERSION --

# Create RBAC resources for NFS storage provisioning
kubectl create -f assets/nfs-storage/rbac-nfs-storage.yaml

# Create a deployment for the NFS storage provisioner
kubectl create -f assets/nfs-storage/depl-storage-provisioner.yaml

# Create a storage class for NFS storage
kubectl create -f assets/nfs-storage/sc-nfs-storage.yaml

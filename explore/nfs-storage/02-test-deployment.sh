#!/bin/bash

# Create a persistent volume claim for the test pod
kubectl create -f explore/nfs-storage/pvc-test-nfs-storage.yaml

# Create a test pod that uses the NFS storage
kubectl create -f explore/nfs-storage/pod-test-nfs-storage.yaml
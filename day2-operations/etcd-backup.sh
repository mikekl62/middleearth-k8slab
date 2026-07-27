#!/bin/bash

ETCDCTL_API=3
ETCD_ENDPOINTS=https://192.168.2.110:2379
SNAPSHOT_LOCATION=/tmp/etcd-snapshot.db

# Create a snapshot of the etcd database
sudo etcdctl --endpoints=$ETCD_ENDPOINTS \
             --cacert /etc/kubernetes/pki/etcd/ca.crt \
             --cert /etc/kubernetes/pki/etcd/server.crt \
             --key /etc/kubernetes/pki/etcd/server.key \
             snapshot save $SNAPSHOT_LOCATION

# Verify the snapshot
sudo etcdctl --endpoints=$ETCD_ENDPOINTS \
             --cacert /etc/kubernetes/pki/etcd/ca.crt \
             --cert /etc/kubernetes/pki/etcd/server.crt \
             --key /etc/kubernetes/pki/etcd/server.key \
             --write-out=table \
             snapshot status $SNAPSHOT_LOCATION
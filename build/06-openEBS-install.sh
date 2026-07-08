#!/bin/bash

#####################################
# Install OpenEBS
#
# To be executed on each worker node.
#####################################

# Setup helm repository
helm repo add openebs https://openebs.github.io/openebs
helm repo update

# Install the OpenEBS helm chart
helm install openebs --namespace openebs openebs/openebs \
                     --set engines.replicated.mayastor.enabled=false \
                     --create-namespace

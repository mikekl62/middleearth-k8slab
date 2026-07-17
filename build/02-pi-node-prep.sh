#!/bin/bash

#################################################################################
# Raspberry PI node preparations
#
# To be executed on master and all worker nodes.
#
# References:
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# https://github.com/piyushsachdeva/CKA-2024/blob/main/Resources/Day27/readme.md
#
################################################################################

##########################
# 1 - Enable memory cgroup
##########################

# Append memory cgroup params to the first line
sudo sed -i '1 s/$/ cgroup_enable=memory cgroup_memory=1/' /boot/firmware/cmdline.txt

##################
# 2 - Disable swap
##################

# Make swap settings persistent across reboots
sudo mkdir -p /etc/rpi/swap.conf.d
cat <<EOF | sudo tee /etc/rpi/swap.conf.d/k8s.conf
[Main]
Mechanism=none
EOF

# Aooply without reboot
sudo swapoff -a

####################################
# 3 - Load networking kernel modules
####################################

# Make module loading persistent across reboots
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Apply without reboot
sudo modprobe overlay
sudo modprobe br_netfilter

# Verify that the modules are loaded
lsmod | grep br_netfilter
lsmod | grep overlay

#####################################
# 4 - Set networking system variables
#####################################

# Make settings persistent across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward  = 1
EOF

# Apply without reboot
sudo sysctl --system

# Verify that system variables are set
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
sysctl net.ipv4.ip_forward

#
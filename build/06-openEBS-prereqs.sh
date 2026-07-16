#!/bin/bash

############################################
# Install OpenEBS Local PV LVM prerequisites
#
# To be executed on each worker node.
############################################

############################
# 1 - Install LVM2 utilities
############################

sudo apt update
sudo apt install lvm2

#######################################
# 2 - Load device mapper snashot module
#######################################

# Make module loading persistent across reboots
cat <<EOF | sudo tee /etc/modules-load.d/openebs.conf
dm-snapshot
EOF

# Apply without reboot
sudo modprobe dm-snapshot

###########################################
# 3 - Create a LVM volume group for OpenEBS
###########################################

# Create a 10G disk image and loopback device
sudo truncate -s 10240M /var/opt/openebs/disk.img
sudo losetup /dev/loop0 /var/opt/openebs/disk.img

# Create a volume group
sudo pvcreate /dev/loop0
sudo vgcreate vg_localpv_lvm /dev/loop0

# Use rc.local to recreate loopback device after reboot
sudo cp scripts/rc.local /etc
sudo cp scripts/rc.local.service /etc/systemd/system

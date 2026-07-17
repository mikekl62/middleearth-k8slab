#!/bin/bash

############################################
# Install OpenEBS Local PV LVM prerequisites
#
# To be executed on each worker node.
############################################

########################################
# 1 - Ensure global variables are loaded
########################################

# The directory of the current script is retrieved to ensure
# portability, then we CD into that directory to ensure we are
# the git repo tree.

if [ -z "${REPO_ROOT+x}" ]; then
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd $DIR && source 00-global-vars.sh
fi

############################
# 2 - Install LVM2 utilities
############################

sudo apt update
sudo apt install lvm2

#######################################
# 3 - Load device mapper snashot module
#######################################

# Make module loading persistent across reboots
cat <<EOF | sudo tee /etc/modules-load.d/openebs.conf
dm-snapshot
EOF

# Apply without reboot
sudo modprobe dm-snapshot

###########################################
# 4 - Create a LVM volume group for OpenEBS
###########################################

# Create a 10G disk image and loopback device
sudo truncate -s 10240M $OPENEBS_DISK_IMAGE
sudo losetup $OPENEBS_LOOP_DEV $OPENEBS_DISK_IMAGE

# Create a volume group
sudo pvcreate $OPENEBS_LOOP_DEV
sudo vgcreate $OPENEBS_VOLUME_GROUP $OPENEBS_LOOP_DEV

################################################
# 5 - Recreation of loopback device after reboot
################################################

sudo cp $REPO_ROOT/assets/openebs-backing-storage.sh /etc/init.d
sudo chmod 755 /etc/init.d/openebs-backing-storage.sh

sudo cp $REPO_ROOT/assets/openebs-backing-storage.service /etc/systemd/system
sudo chmod 644 /etc/systemd/system/openebs-backing-storage.service

sudo ln -s ../init.d/openebs-backing-storage.sh /etc/rc3.d/S02openebs

sudo systemctl daemon-reload
sudo systemctl enable openebs-backing-storage.service

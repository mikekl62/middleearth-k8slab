#!/bin/bash

# List loop devices
losetup -a

# Current loop device
export LOOPDEV=loop0
export LOOPMNT=/snap/snapd/26383

# Delete loop device
sudo umount $LOOPMNT
sudo losetup -d /dev/$LOOPDEV
sudo rm /dev/$LOOPDEV

# Recreate lost loop device 
sudo mknod /dev/loop0 b 7 0
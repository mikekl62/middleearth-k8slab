#!/bin/bash

# Disk image folder and full path
export DISKIMG_DIR=/var/opt/openebs
export DISKIMG=$DISKIMG_DIR/disk0.img

# Create a 10GB empty disk image
sudo mkdir -p $DISKIMG_DIR
sudo dd if=/dev/zero of=$DISKIMG bs=1G count=10 status=progress

# Associate it with a free loop device
LOOPDEV=$(sudo losetup -f --show "$DISKIMG")

# Format the disk image with ext4 filesystem
sudo mkfs -t ext4 $LOOPDEV

# Create a mount point and mount it
sudo mkdir -p /mnt/openebs
sudo mount "$LOOPDEV" /mnt/openebs

# Use it like a normal disk
sudo touch /mnt/loop_mount/hello.txt
ls -l /mnt/loop_mount

# Unmount and detach when done
sudo umount /mnt/loop_mount
sudo losetup -d "$loopdev"

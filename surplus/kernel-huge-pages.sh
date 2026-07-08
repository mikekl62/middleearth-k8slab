#!/bin/bash

##############################################################
# Recompile Linux Kernel To Enable HUGEPAGES On Raspberry Pi 5
##############################################################

# Procedure taken from https://gist.github.com/Justin0dev/66d56e8ca0892c6d22369a6f54983fbb

######################
# Install dependencies
######################

sudo apt update
sudo apt install -y git build-essential bc bison kmod cpio flex libncurses5-dev libelf-dev libssl-dev

################################################
# Clone the Raspberry Pi Linux Kernel Repository
################################################

cd ~/dev
git clone --depth=1 https://github.com/raspberrypi/linux
cd linux

########################################
# Backup .config file before customizing
########################################

cp .config .config.backup

# Beware that the .config file is not present until the following command
# is ran which generates a fresh basic .config file.

##################
# Configure Kernel
##################

KERNEL=kernel_2712
make bcm2712_defconfig

#####################################################
# Enable hugepage support in the kernel configuration 
#####################################################

sed -i 's/# CONFIG_HUGETLBFS.*/CONFIG_HUGETLBFS=y/' .config
sed -i 's/# CONFIG_TRANSPARENT_HUGEPAGE.*/CONFIG_TRANSPARENT_HUGEPAGE=y/' .config
sed -i 's/# CONFIG_HUGETLB_PAGE.*/CONFIG_HUGETLB_PAGE=y/' .config 
sed -i 's/# CONFIG_ARCH_HAS_HUGEPD.*/CONFIG_ARCH_HAS_HUGEPD=y/' .config
sed -i 's/# CONFIG_HUGETLB_PAGE_SIZE_VARIABLE.*/CONFIG_HUGETLB_PAGE_SIZE_VARIABLE=y/' .config
sed -i 's/# CONFIG_ARCH_WANT_GENERAL_HUGETLB.*/CONFIG_ARCH_WANT_GENERAL_HUGETLB=y/' .config
sed -i 's/# CONFIG_SYSFS.*/CONFIG_SYSFS=y/' .config
sed -i 's/# CONFIG_CHECKPOINT_RESTORE.*/CONFIG_CHECKPOINT_RESTORE=y/' .config
sed -i 's/# CONFIG_HIGH_RES_TIMERS.*/CONFIG_HIGH_RES_TIMERS=y/' .config

##################
# Build the kernel
##################

# Expect up to 2 hours execution time

make -j4 Image.gz modules dtbs

# Additional settings
#
#   HugeTLB controller (CGROUP_HUGETLB): y
#   Sysfs syscall support (SYSFS_SYSCALL): y
#   Contiguous PTE mappings for user memory (ARM64_CONTPTE): y
#   Allocate a PMD sized folio for zeroing (PERSISTENT_HUGE_ZERO_FOLIO): y
#   Transparent Hugepage Support sysfs defaults: choice 1
#   Read-only THP for filesystems (EXPERIMENTAL) (READ_ONLY_THP_FOR_FS): n
#   No per-page mapcount (EXPERIMENTAL) (NO_PAGE_MAPCOUNT): n

###################¤
# Install the kernel
####################

sudo make modules_install
sudo cp arch/arm64/boot/dts/broadcom/*.dtb /boot/firmware/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/firmware/overlays/
sudo cp arch/arm64/boot/dts/overlays/README /boot/firmware/overlays/
sudo cp arch/arm64/boot/Image.gz /boot/firmware/$KERNEL.img
sudo cp arch/arm64/boot/Image.gz /boot/firmware/kernel8hp.img

###########################
# Configure the boot loader
###########################

sudo vim /boot/firmware/config.txt

# Add following line to config.txt and comment out any existing kernel settings
# kernel=kernel8hp.img

###############
# Reboot the Pi
###############

sudo reboot

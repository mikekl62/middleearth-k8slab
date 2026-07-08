#!/bin/bash

################################################
# Enable key based authentication
#
# To be executed on master and all worker nodes.
################################################

# Execute ssh-add -L on trusted workstations and paste the output here
SSH_PUBLIC_KEY='{{paste-trusted-public-key-here}}'

#############################################
# 1 - Create a SSH folder and set permissions
#############################################

mkdir $HOME/.ssh
chmod 700 $HOME/.ssh

##################################################################
# 2 - Create an empty file for authorized keys and set permissions
##################################################################

touch $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

###############################################
# 3 - Add trusted public key to authorized keys
###############################################

echo $SSH_PUBLIC_KEY >> $HOME/.ssh/authorized_keys

#####################################
# 4 - Disable password authentication
#####################################

sudo sed -Ei 's/^#*PasswordAuthentication (yes|no)/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

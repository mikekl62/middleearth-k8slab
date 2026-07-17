#!/bin/bash

OPENEBS_DISK_IMAGE=/var/opt/openebs/disk.img
OPENEBS_LOOP_DEV=/dev/loop0
OPENEBS_VOLUME_GROUP=vg_localpv_lvm
REPO_ROOT=$(git rev-parse --show-toplevel)

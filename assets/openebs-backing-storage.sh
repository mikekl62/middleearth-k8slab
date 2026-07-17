#!/bin/bash

LOOPDEV=/dev/loop0
DISKIMG=/var/opt/openebs/disk.img

case "$1" in
  start)
    if [ -e "$DISKIMG" ]; then
        sudo losetup $LOOPDEV $DISKIMG
    else
        echo "No disk image found, aborting"
        exit 2
    fi
    ;;
  stop)
    sudo losetup -d $LOOPDEV
    ;;
  *)
    echo "Usage: /etc/init.d/openebs-backing-storage.sh {start|stop}"
    exit 1
    ;;
esac
exit 0



exit 0

#!/bin/bash
# Description: Chroot binary and library setup script
# Author: Tekfik Blogging

CHROOT_DIR=$1
CHGROUP=$2
TARG=$#

## Check input args
if [ $TARG != 2 ];then
    echo "Bad Input. Execute the script as:"
    echo "sh chroot-base-setup.sh chroot_dir_location chroot_group_name"
    exit 1
fi

## Check and setup chroot dir 
if [ ! -d $CHROOT_DIR ]; then
    mkdir -p $CHROOT_DIR
    mkdir -p $CHROOT_DIR/{bin,usr,etc,lib64,home,dev}
    cd $CHROOT_DIR/usr
    ln -sf ../bin ./bin
    ln -sf ../lib64 ./lib64
    ##Dev Setup
    mknod -m 666 $CHROOT_DIR/dev/null c 1 3
    mknod -m 666 $CHROOT_DIR/dev/tty c 5 0
    mknod -m 666 $CHROOT_DIR/dev/zero c 1 5
    mknod -m 666 $CHROOT_DIR/dev/random c 1 8
    chmod o+t $CHROOT_DIR/dev/null $CHROOT_DIR/dev/tty $CHROOT_DIR/dev/zero $CHROOT_DIR/dev/random

    #Group setup
    if [[ ! `getent group $CHGROUP 2>/dev/null` ]];then
       groupadd $CHGROUP
    fi

else
    echo "Chroot setup already present. Delete the present chroot directory $CHROOT_DIR to setup from new."
    exit 0
fi

## Setup Complete
echo -e "\n\n============================Setup completed============================\n\n"
echo -e "1) Append the following configuration /etc/ssh/sshd_config file \
and then restart sshd service"

echo -e "\n## Chroot SSH configuration\nMatch Group $CHGROUP\n\tChrootDirectory $CHROOT_DIR \
\n\tX11Forwarding no\n\tAllowTcpForwarding no"

echo -e "\n\n2) Run chroot-binary-setup.sh script to setup allowed commands \
for chroot ssh user \n\n3) Execute chroot-user-setup.sh script to setup chroot users."

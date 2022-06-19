#!/bin/bash
# Description    : Chroot binary and library setup script
# Orginal Author : Tekfik Blogging
# Modified       : Al Muhdil Karim

echo '--------------------------------------------------------';
echo 'Insert Chroot directory, Example : /home/chroot ';
echo '--------------------------------------------------------';
read -p 'CHROOT DIRECTORY: ' chrootDir

CHROOT_DIR=$chrootDir

## Check dir args
if [ -z "${CHROOT_DIR}" ];then
    echo "Execution Failed:"
    echo "Chroot directory is empty"
    echo "please fill this field using path of directory"
    exit 1
fi


echo '--------------------------------------------------------';
echo 'Create New Unix groups for chroot, Example : chgroups ';
echo '--------------------------------------------------------';
read -p 'CHROOT GROUPS: ' chrootGroup

CHGROUP=$chrootGroup

## Check groups args
if [ -z "${CHGROUP}" ];then
    echo "Execution Failed:"
    echo "Chroot Group is empty"
    echo "Please fill this field using of groups name for chroot users"
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

    touch $CHROOT_DIR/etc/profile
    echo "export PATH=$PATH:/bin" >> $CHROOT_DIR/etc/profile
    
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

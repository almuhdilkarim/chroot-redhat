
#!/bin/bash
# Description: Chroot binary and library setup script
# Author: Tekfik Blogging


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


echo '--------------------------------------------------------';
echo ' Create New User for chroot, Example : ana ';
echo '--------------------------------------------------------';
read -p 'CHROOT GROUPS: ' chrootUser

USER=$chrootUser

## Check groups args
if [ -z "${USER}" ];then
    echo "Execution Failed:"
    echo "Username Group is empty"
    echo "Please fill this field using of groups name for chroot users"
    exit 1
fi




## Check chroot dir 
if ! test -d $CHROOT_DIR -a -d $CHROOT_DIR/bin -a -d $CHROOT_DIR/usr -a -d $CHROOT_DIR/etc -a -d $CHROOT_DIR/lib64 -a -d $CHROOT_DIR/home -a -d $CHROOT_DIR/dev;then
    echo "Chroot directory structure is not found. Execute chroot-base-setup.sh script to setup chroot dir structure."
    exit 1
fi

## Add user
if [[ ! -n `id -u $USER 2>/dev/null` ]];then
    echo "Setting up user account $USER"
    sleep 2
    /usr/sbin/useradd -m -g $USER -G $CHGROUP $USER
    mkdir -p $CHROOT_DIR/home/$USER
    chown $USER:$CHGROUP $CHROOT_DIR/home/$USER
    chmod 700 $CHROOT_DIR/home/$USER
    ln -sf $CHROOT_DIR/home/$USER /home/$USER
    ## Set user password
    passwd $USER
else
    echo "User $USER already present."
fi

echo -e "\n\n"
echo "User setup completed. Now you can test chroot ssh login."

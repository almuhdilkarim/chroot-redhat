
#!/bin/bash
# Description: Chroot binary and library setup script
# Author: Tekfik Blogging

CHROOT_DIR="/data/chroot-ssh"
CHGROUP="chrootssh"
USER=$1
TARG=$#

## Check input args
if [ $TARG != 1 ];then
    echo "Bad Input. Modify the variable value of CHROOT_DIR and CHGROUP variables and then execute the script as:"
    echo "sh chroot-user-setup.sh user_name"
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
    /usr/sbin/useradd -g $CHGROUP -M -s /bin/bash $USER
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

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
echo 'Insert Binary Path for chroot, Example : /bin/ls ';
echo '--------------------------------------------------------';
read -p 'Binary Path: ' BinPath

BINARY_PATH=$BinPath

## Check groups args
if [ -z "${BINARY_PATH}" ];then
    echo "Execution Failed:"
    echo "Binary path is empty"
    echo "Please fill this field using of path of binary"
    exit 1
fi



## Check chroot dir 
if ! test -d $CHROOT_DIR -a -d $CHROOT_DIR/bin -a -d $CHROOT_DIR/usr -a -d $CHROOT_DIR/etc -a -d $CHROOT_DIR/lib64 -a -d $CHROOT_DIR/home -a -d $CHROOT_DIR/dev;then
    echo "Chroot directory structure is not found. Execute chroot-base-setup.sh script to setup chroot dir structure."
    exit 1
fi

## Check binary existence
if [ ! -f $BINARY_PATH ]; then
    echo "Binary $BINARY_PATH doesn't exist. Re-execute script with proper binary path"
    exit
fi

## Binary setup
cp -p $BINARY_PATH $CHROOT_DIR/bin/

B_LIB=$(ldd $BINARY_PATH |grep -v dynamic|awk -F " " '{print $3}'|grep -v "^$"|grep -v "^(")

for i in $B_LIB;do
    if [ -f $i ]; then
        cp --parent $i $CHROOT_DIR/
    else
        echo "$i doesn't exist, check manually on the system"
    fi
done

## Additional setup 
# x86_64 arc
if [ -f /lib64/ld-linux-x86-64.so.2 ] && [ ! -f $CHROOT_DIR/lib64/ld-linux-x86-64.so.2 ]; then
   cp --parents /lib64/ld-linux-x86-64.so.2 $CHROOT_DIR/
fi

# 32 bit arc
if [ -f  /lib/ld-linux.so.2 ] && [ ! -f $CHROOT_DIR/lib/ld-linux.so.2 ]; then
   cp --parents /lib/ld-linux.so.2 $CHROOT_DIR/
fi

echo -e "\nBinary setup completed. Now execute chroot-user-setup.sh script to create chroot users."

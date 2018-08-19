#!/bin/sh -ex

APP=donkey
IMG=${APP}.img
KERNEL=$1
INITRD=$2

MNTPNT=/media/usb
SIZE=1G

qemu-img create -f raw  $IMG $SIZE
sudo dd if=/usr/lib/syslinux/mbr/mbr.bin of=$IMG conv=notrunc bs=440 count=1
parted -s $IMG mklabel msdos
parted -s -a none $IMG mkpart primary ext4 0 $SIZE
parted -s -a none $IMG set 1 boot on

lodev=$(losetup -f)
sudo losetup $lodev $IMG
sudo partx -a $lodev
sudo mkfs.ext4 ${lodev}p1

sudo mount ${lodev}p1 $MNTPNT
sudo mkdir -p $MNTPNT/boot/extlinux
sudo cp extlinux.conf $MNTPNT/boot/extlinux/
sudo cp $KERNEL $MNTPNT/boot/
sudo cp $INITRD $MNTPNT/boot/
sudo extlinux --install $MNTPNT/boot/extlinux/
sudo umount $MNTPNT

sudo partx -d $lodev
sudo losetup -d $lodev

#!/bin/bash

STAGE4_IMAGE=$1
CHROOT_TARGET=$2

cd ${CHROOT_TARGET}
tar xvjpf ${STAGE4_IMAGE} -c /mnt/gentoo
cp -vR ${CHROOT_TARGET}/bootcpy/* ${CHROOT_TARGET}/boot/
rm -rf ${CHROOT_TARGET/bootcpy
mknod -m 660 ${CHROOT_TARGET}/dev/console c 5 1
mkdod -m 660 ${CHROOT_TARGET}/dev/null c 1 3
mknod -m 660 ${CHROOT_TARGET}/dev/initctl p
mknod -m 660 ${CHROOT_TARGET}/dev/tty1 c 4 1
mount -t proc none ${CHROOT_TARGET}/proc
mount -t sysfs none ${CHROOT_TARGET}/sys
mount -o bind /dev ${CHROOT_TARGET/dev
mount -o bind /dev/pts ${CHROOT_TARGET/dev/pts
cd ${CHROOT_TARGET}/usr
wget  http://gentoo.osuosl.org/snapshots/portage-latest.tar.bz2
tar xvjf portage-latest.tar.bz2

echo "chroot ${CHROOT_TARGET}"
echo "env-update; source /etc/profile"


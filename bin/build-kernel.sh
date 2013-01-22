#/bin/bash


linux_src=/usr/src/linux-stable

export $(head -n3 Makefile | sed 's/ //g' )
kernel_name="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${CONFIG_LOCALVERSION}-$(date +%y%m%d%H%M)"

jobs=$(expr $(grep name /proc/cpuinfo|wc -l) * 2)

echo -=- Building Kernel
cd /usr/src/linux-stable
make -j${jobs} bzImage

echo -=- Copying vmlinuz, vmlinux and config files
cp /usr/src/linux-stable/arch/x86/boot/bzImage /home/kyle/objects/kernel/vmlinuz-$kernel_name
cp /usr/src/linux-stabe/arch/x86/boot/vmlinux.bin /home/kyle/objects/kernel/vmlinux-$kernel_name
cp /usr/src/linux-stabe/.config /home/kyle/objects/kernel/config-$kernel_name

echo -=- Done!

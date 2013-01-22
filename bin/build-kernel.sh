#/bin/bash

function shellout {
  echo -=- command failed, shelling out!
  exit 1
}

function build_kernel{
  linux_src="/usr/src/linux-stable"

  export $(head -n3 ${linux_src}/Makefile | sed 's/ //g' || shellout())
  kernel_name="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${CONFIG_LOCALVERSION}-$(date +%y%m%d%H%M)"
  jobs=$(expr $(grep name /proc/cpuinfo|wc -l) * 2)

  echo -=- Build Kernel
  cd /usr/src/linux-stable || shellout()
  make -j${jobs} bzImage || shellout()

  echo -=- Push Kernel Files
  /usr/bin/s3cmd -c ${HOME}/.s3cfg put /usr/src/linux-stable/arch/x86/boot/bzImage s3://hardened/kernel/vmlinuz-$kernel_name || shellout()
  /usr/bin/s3cmd -c ${HOME}/.s3cfg put /usr/src/linux-stable/arch/x86/boot/vmlinux.bin s3://hardened/kernel/vmlinux-$kernel_name || shellout()
  /usr/bin/s3cmd -c ${HOME}/.s3cfg put /usr/src/linux-stable/.config s3://hardened/kernel/config-$kernel_name || shellout()

  echo -=- Done!
}

build_kernel()

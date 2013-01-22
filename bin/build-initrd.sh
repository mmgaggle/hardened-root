#!/bin/bash

function usage {
  echo "build-initrd.sh <initrd_name>"
  exit 1
}

if [ -x $initrd_name ];then
  # eg. 'stage4' or 'hardened-base'
  initrd_name=$1
else 
  usage()
fi

initrd_dir="/root/initrd"
initrd_path="$initrd_dir/initrd-$initrd_name-$(date +%y%m%d%H%M)"

echo -=- Building initrd
cd $initrd_dir/initrd-$initrd_name
find . -print0 | cpio -ov -0 --format=newc | gzip -9 > /root/objects/initrd/$initrd_path

echo -=- Done!

#!/bin/bash

function usage {
  echo "build-initrd.sh <initrd_name>"
  exit 1
}

function shellout {
  echo -=- command failed, shelling out!
  exit 1
}

function build_initrd {
  initrd_name="$1"
  date_suffix="$(date +%y%m%d%H%M)"
  bucket="hardened"
  if [ -z ${initrd_name} ];then
    echo -=- Determine path
    initrd_dir="/root/workspace/initrd/${initrd_name}"
    initrd_path="${initrd_dir}-${date_suffix}.tgz"

    echo -=- Build initrd
    cd ${initrd_dir}/initrd-${initrd_name} || shellout
    find . -print0 | cpio -ov -0 --format=newc | gzip -9 > $initrd_path || shellout

    echo -=- Push initrd
    s3put /root/workspace/initrd/${initrd_path} s3://${bucket}/initrd/${initrd_name}|| shellout

    echo -=- Done!
  else
    usage()
  fi
}

build_initrd($1)

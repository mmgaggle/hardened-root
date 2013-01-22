#! /bin/bash

function shellout {
  echo -=- command failed, shelling out!
  exit 1
}

function build_stage4 {
  stage_name="hardened-base-$(date +%y%m%d%H%M)"
  stages_dir="/root/workspace/stages"
  bucket="hardened"



  dir_excludes="/mnt/* \
                /dev \
                /proc \
                /sys \
                /tmp \
                /usr/portage \
                /var/tmp \
                /var/log \
                /home \
                /root \
                /usr/src"

  file_excludes="/etc/ssh/ssh_host_dsa_key \
                 /etc/ssh/ssh_host_dsa_key.pub \
                 /etc/ssh/ssh_host_rsa_key \
                 /etc/ssh/ssh_host_rsa_key.pub \
                 /etc/udev/rules.d/70-persistent-net.rules"

  excludes="$(for i in $dir_excludes; do if [ -d $i ]; then \
      echo -n " --exclude=$i/*"; fi; done) $(for i in $file_excludes; do \
      echo -n " --exclude=$i"; done)"

  tar_options="$excludes --create --absolute-names --bzip2 --verbose --totals --file"

  echo -=- Starting stage 4 build
  echo -=- Target: ${stages_dir}/${stage_name}
  echo -=- Running:
  echo -=- tar ${tar_options} ${stages_dir}/${stage_name}.tar.bz2 /
  tar ${tar_options} ${stages_dir}/${stage_name}.tar.bz2 / || shellout

  echo -=- Finished Stage 4 build

  echo -=- Pushing stage 4 build to DreamObjects
  /usr/bin/s3cmd -c ${HOME}/.s3cfg put ${stages_dir}/${stage_name}.tar.bz2 s3://${bucket}/stages/${stage_name}.tar.bz2 || shellout

  echo -=- Done!
}


build_stage4

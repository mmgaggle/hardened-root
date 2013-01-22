#! /bin/bash

stage_name="hardened-base-$(date +%y%m%d%H%M)"
stages_dir=/root/objects/stages

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

tar_ptions="$excludes --create --absolute-names --bzip2 --verbose --totals --file"

echo -=- Starting stage 4 build
echo -=- Target: $stages_dir/$stage_name
echo -=- Running:
echo -=- tar ${tar_options} ${stages_dir}/${stage_name} /
tar ${tar_options} ${stages_dir}/${stage_name} /;

echo -=- Finished Stage 4 build!

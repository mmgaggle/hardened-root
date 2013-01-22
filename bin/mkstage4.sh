#! /bin/bash
##  Backup script for Gentoo Linux
##  Change Log

##  2006.07.20 by odessit
##  Added symmetric & asymmetric encryption options to the script using GnuPG
##  to accomodate secure environments

##  Date: 2006.03.05 by BrianW
##  Initial Script
##  Adapted from backupHome.sh by fdavid
##  Adapted from mkstage4.sh by nianderson

##  This is a script to create a custom stage 4 tarball (System and boot backup)
##  I use this script to make a snapshot of my system. Meant to be done weekly in my case

##  Please check the options and adjust to your specifics.

echo -=- Starting the Backup Script...
echo -=-

echo -=- Setting the variables...

stage4name='hardened-base'

##  The location of the stage 4 tarball.
##  Be sure to include a trailing /
stage4Location=/home/kbcompute/objects/stages

##  The name of the stage 4 tarball.
archive=$stage4Location$stage4name-stage4.tar.bz2

##  Directories/files that will be exluded from the stage 4 tarball.
##
##  Add directories that will be recursively excluded, delimited by a space.
##  Be sure to omit the trailing /
dir_excludes="/mnt/* /dev /proc /sys /tmp /usr/portage /var/tmp /var/log/* /home/* /root/*"
##
##  Add files that will be excluded, delimited by a space.
##  You can use the * wildcard for multiple matches.
##  There should always be $archive listed or bad things will happen.
file_excludes="$archive \
               /etc/ssh/ssh_host_dsa_key  \
	       /etc/ssh/ssh_host_dsa_key.pub \
               /etc/ssh/ssh_host_rsa_key  \
	       /etc/ssh/ssh_host_rsa_key.pub \
	       /etc/udev/rules.d/70-persistent-net.rules"
##
##  Combine the two *-excludes variables into the $excludes variable
excludes="$(for i in $dir_excludes; do if [ -d $i ]; then \
    echo -n " --exclude=$i/*"; fi; done) $(for i in $file_excludes; do \
    echo -n " --exclude=$i"; done)"

##  The options for the stage 4 tarball.
tarOptions="$excludes --create --absolute-names --bzip2 --verbose --totals --file"

echo -=- Done!
echo -=-

##  Mounting the boot partition
echo -=- Mounting boot partition, then sleeping for 5 seconds...
mount /boot
sleep 5
echo -=- Done!
echo -=-

## Omit /boot stuffs because machine is booted from network

##  Creating a copy of the boot partition (copy /boot to /bootcpy).
##  This will allow the archiving of /boot without /boot needing to be mounted.
##  This will aid in restoring the system.
#echo -=- Copying /boot to /bootcpy ...
#cp -R /boot /bootcpy
#echo -=- Done!
#echo -=-

##  Unmounting /boot
#echo -=- Unmounting /boot then sleeping for 5 seconds...
#umount /boot
#sleep 5
#echo -=- Done!
#echo -=-

##  Creating the stage 4 tarball.
echo -=- Creating custom stage 4 tarball \=\=\> $archive
echo -=-
echo -=- Running the following command:
echo -=- tar ${tarOptions} ${archive} /
tar ${tarOptions} ${archive} /;
echo -=- Done!


##  Uncomment this portion to encrypt the stage4 using asymmetric encryption with GnuPG
##  To get a list of available ciphers on your machine do #gpg --version
##  Note: only aes aes192 aes256 and twofish should be used for large files (~1Gig & larger)
##  To Restore: (cat together if split) and #gpg stage4.tar.bz2.gpg
#echo -=- Starting Encryption Process usung asymmetric encryption with a public key  -=-
#cd $stage4Location
#gpg --encrypt --batch --recipient [MY_PUB_KEY] --cipher-algo twofish --output $archive.gpg $archive
#rm $archive
#archive=$stage4Location$(hostname)-stage4.tar.bz2.gpg

##  Uncomment this portion to encrypt the stage4 using symmetric encryption with GnuPG
##  ##  To get a list of ciphers on your machine do #gpg --version
##  Note: only aes aes192 aes256 and Twofish should be used for large files (~1 gig & larger)
##  To Restore: (cat together if split) and #gpg stage4.tar.bz2.gpg
#echo -=- Starting Encryption Process usung symmetric encryption with a password  -=-
#cd $stage4Location
#pass=PLEASE_CHANGE_ME_I_BEG_YOU!
#echo $pass | gpg --batch --cipher-algo twofish --passphrase-fd 0 --symmetric $archive
#rm $archive
#archive=$stage4Location$(hostname)-stage4.tar.bz2.gpg

##  Split the stage 4 tarball in cd size tar files.
##  To combine the tar files after copying them to your
##  chroot do the following: "cat *.tar.bz2 >> stage4.tar.bz2".
##  or if encrypted do the following: "cat *.tar.bz2.gpg >> stage4.tar.bz2.gpg".
##  Uncomment the following lines to enable this feature.
#echo -=- Splitting the stage 4 tarball into CD size tar files...
#split --bytes=700000000 ${archive} ${archive}.
#echo -=- Done!

##  Removing the directory /bootcpy.
##  You may safely uncomment this if you wish to keep /bootcpy.
echo -=- Removing the directory /bootcpy ...
rm -rf /bootcpy
echo -=- Done!
echo -=-

##  This is the end of the line.
echo -=- The Backup Script has completed!

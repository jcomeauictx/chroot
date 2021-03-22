#!/bin/bash -x
chrootdir="${1:-/mnt/new/opt/jessie32}"
dirs="proc /sys /dev /home /usr/src /mnt/*"
files="/etc/mtab"  # NOTE: do NOT add /etc/{passwd,group,shadow}, BAD idea!
for dir in $dirs $files; do
	if [ "${dir:0:1}" = "/" ]; then
		mount --bind $dir $chrootdir$dir
	elif [ "$dir" = "/sys" ]; then
		mount -t sysfs sysfs $dir
	else
		mount -t $dir $dir $chrootdir/$dir
	fi
done
chroot $chrootdir
for dir in $(echo $dirs $files | tr " " "\n" | tac); do
	if [ "${dir:0:1}" = "/" ]; then
		umount $chrootdir$dir
	else
		umount $chrootdir/$dir
	fi
done

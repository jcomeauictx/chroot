#!/bin/bash -x
chrootdir="${1:-/opt/stretch32}"
username="${2:-$USER}"
dirs="/proc /sys /dev /home /usr/src /mnt"
files="/etc/mtab"
for dir in $dirs $files; do
	sudo mount --bind $dir $chrootdir$dir
done
sudo chroot $chrootdir /bin/bash -c "su - $username"
for dir in $(echo $dirs $files | tr " " "\n" | tac); do
	sudo umount $chrootdir$dir
done

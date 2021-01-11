#!/bin/sh
ROOTFS="/tmp/rootfs"
sed -i 's/httpd/httpd dropbear dockerd/' $ROOTFS/etc/rcS.conf
echo 'echo "tux:tux" | chpasswd ' >> $ROOTFS/etc/init.d/local.sh
sed -i 's/poweroff/sudo \/etc\/init.d\/dockerd stop || poweroff/' $ROOTFS/usr/bin/tazbox
sed -i 's/reboot || reboot -f/sudo \/etc\/init.d\/dockerd stop || reboot || reboot -f/' $ROOTFS/usr/bin/tazbox
tazpkg install linux64-3.16.55.tazpkg --root=$ROOTFS --nodeps --local --forced
tazpkg install sudocn*.tazpkg --root=$ROOTFS --local
tazpkg -gi curl --root=$ROOTFS 
tazpkg -gi git --root=$ROOTFS
tazpkg -gi xz --root=$ROOTFS
yes | tazpkg -gi bash --root=$ROOTFS
tazpkg -gi linux64-netfilter --root=$ROOTFS
tazpkg -gi iptables --root=$ROOTFS
tazpkg -gi xorg-xf86-video-vmware --root=$ROOTFS 
tazpkg -gi xorg-xf86-input-vmmouse --root=$ROOTFS
tazpkg -gi locale-zh_CN-extra --root=$ROOTFS 
tazpkg install dockerd.tazpkg --root=$ROOTFS --local
cat << EOF | chroot $ROOTFS
mkdir -p /etc/skel/.config/slitaz
echo "root" > /etc/skel/.config/slitaz/subox.conf
tazpkg setup-mirror http://mirror1.slitaz.org/packages/5.0/
tazpkg clean-cache
cd /var/lib/tazpkg
rm packages.*
rm ID*
rm files*
rm *.txt
rm extra.list
cp -f /etc/skel/.profile /etc/skel/.bashrc
EOF


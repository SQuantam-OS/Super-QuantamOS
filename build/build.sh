#!/bin/bash

sudo apt-get update
sudo apt-get install -y gcc g++ make libncurses5-dev libssl-dev bc cdrkit syslinux
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.2.tar.xz
tar -xf linux-6.10.2.tar.xz
cd linux-6.10.2
# Fix #18
make menuconfig
make -j$(nproc)
sudo make modules_install
sudo make install
cd ..
wget https://busybox.net/downloads/busybox-1.33.1.tar.bz2
tar -xjf busybox-1.33.1.tar.bz2
cd busybox-1.33.1
make defconfig
make -j$(nproc)
make install
cd ..
mkdir -p quantam/rootfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}
cp -a busybox-1.33.1/_install/* quantam/rootfs/
echo "::sysinit:/etc/init.d/rcS" > quantam/rootfs/etc/inittab
mkdir -p quantam/rootfs/etc/init.d
echo -e "#!/bin/sh\nmount -t proc proc /proc\nmount -t sysfs sysfs /sys" > quantam/rootfs/etc/init.d/rcS
chmod +x quantam/rootfs/etc/init.d/rcS
mkdir -p quantam/xorg
cd quantam/xorg
git clone https://gitlab.freedesktop.org/xorg/xserver.git
cd xserver
./autogen.sh
make -j$(nproc)
sudo make install
cd ../../..
mkdir -p quantam/rootfs/etc/X11/xinit
echo "exec /usr/bin/Xorg" > quantam/rootfs/etc/X11/xinit/xinitrc
cd quantam/rootfs
find . | cpio -o --format=newc | gzip > ../initramfs.gz
cd ..
mkdir -p quantam/isolinux
cp /usr/lib/syslinux/isolinux.bin quantam/isolinux/
echo -e "DEFAULT linux\nLABEL linux\n    KERNEL /boot/vmlinuz\n    APPEND root=/dev/ram0 initrd=/boot/initramfs.gz" > quantam/isolinux/isolinux.cfg
mkisofs -o quantamos.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J quantam/rootfs
echo "QuantamOS ISO creation complete: quantamos.iso"

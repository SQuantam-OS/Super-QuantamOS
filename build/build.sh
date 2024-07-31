# QuantamOS OS
# Soon I/GuestSneezeOSDev will make my own kernel meaning it will not be linux based (2 years)
cd ~/
sudo apt-get update
sudo apt-get install gcc g++ make libncurses5-dev libssl-dev bc
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.2.tar.xz
tar -xf linux-6.10.2.tar.xz
cd linux
make -j$(nproc)
make install
cd ..
wget https://busybox.net/downloads/busybox-1.33.1.tar.bz2
tar -xjf busybox-1.33.1.tar.bz2
cd busybox-1.33.1
make menuconfig
make -j$(nproc)
make install
cd ~/
mkdir quantam
cd quantam
mkdir -p rootfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}
cp -a ~/busybox-1.33.1/_install/* rootfs/
echo "::sysinit:/etc/init.d/rcS" > rootfs/etc/inittab
echo "#!/bin/sh" > rootfs/etc/init.d/rcS
echo "mount -t proc proc /proc" >> rootfs/etc/init.d/rcS
echo "mount -t sysfs sysfs /sys" >> rootfs/etc/init.d/rcS
chmod +x rootfs/etc/init.d/rcS
mkdir xorg
cd xorg
git clone https://gitlab.freedesktop.org/xorg/xserver.git
cd xserver
./autogen.sh
make -j$(nproc)
make install
mkdir -p rootfs/etc/X11
echo "exec /usr/bin/Xorg" > rootfs/etc/X11/xinit/xinitrc
# Make initramfs
cd rootfs
find . | cpio -o --format=newc | gzip > ../initramfs.gz





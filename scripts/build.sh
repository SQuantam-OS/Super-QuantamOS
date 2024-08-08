#!/bin/bash
# QuantamOS build.sh fix
# BE ELEVATED WITH SUDO
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo! or else"
    exit 1
fi
# Ok back to the script
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.2.tar.xz
tar -xvf linux-6.10.2.tar.xz
cd linux-6.10.2
make menuconfig
make -j$(nproc)
sudo make modules_install
sudo make install

if [ ! -f /boot/vmlinuz-6.10.2 ]; then
    echo "Kernel image not found! Exiting."
    exit 1
fi

cd ..
mkdir -p quantam/rootfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}

wget https://busybox.net/downloads/busybox-1.33.1.tar.bz2
tar -xvf busybox-1.33.1.tar.bz2
cd busybox-1.33.1
make defconfig
make -j$(nproc)
make install CONFIG_PREFIX=../quantam/rootfs

echo "::sysinit:/etc/init.d/rcS" > ../quantam/rootfs/etc/inittab
mkdir -p ../quantam/rootfs/etc/init.d
echo "#!/bin/sh" > ../quantam/rootfs/etc/init.d/rcS
echo "mount -t proc none /proc" >> ../quantam/rootfs/etc/init.d/rcS
echo "mount -t sysfs none /sys" >> ../quantam/rootfs/etc/init.d/rcS
echo "/sbin/mdev -s" >> ../quantam/rootfs/etc/init.d/rcS
chmod +x ../quantam/rootfs/etc/init.d/rcS

# Use xmonad
sudo apt-get install -y xmonad
cp /usr/bin/xmonad ../quantam/rootfs/usr/bin/
# Uninstall xmonad
sudo apt-get remove xmonad
mkdir -p ../quantam/rootfs/usr/share/X11/xorg.conf.d
# Resolve #7
cd ~/
mkdir -p ~/quantam/rootfs/usr/local/bin
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
cd /usr/local/bin
sudo mv distrobox distrobox-enter distrobox-generate-entry distrobox-list distrobox-upgrade distrobox-assemble distrobox-ephemeral  distrobox-host-exec distrobox-rm distrobox-create  distrobox-export  distrobox-init distrobox-stop ~/quantam/rootfs/usr/local/bin
# Initial patch
cd ~/quantam
cd rootfs
find . | cpio -o --format=newc | gzip > ../initramfs.gz
# I Think that should fix it
mkdir -p ~/iso/boot/grub
cp /boot/vmlinuz-6.10.2 iso/boot/vmlinuz
cp /boot/initramfs.gz iso/boot/initramfs.gz

cat > iso/boot/grub/grub.cfg << EOF
set default=0
set timeout=5

menuentry "QuantamOS" {
    linux /boot/vmlinuz root=/dev/sr0
    initrd /boot/initramfs.gz
}
EOF

grub-mkrescue -o quantam.iso iso

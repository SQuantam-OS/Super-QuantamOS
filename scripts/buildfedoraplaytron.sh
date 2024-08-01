#!/bin/bash
# QuantamOS script for Fedora and PlaytronOS based systems
set -e

sudo dnf update -y
sudo dnf install -y @development-tools ncurses-devel bison flex openssl-devel elfutils-libelf-devel grub2 xorriso ghc cabal-install libX11-devel libXft-devel libXinerama-devel

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
cat > ../quantam/rootfs/etc/init.d/rcS << 'EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
/sbin/mdev -s
EOF
chmod +x ../quantam/rootfs/etc/init.d/rcS

sudo dnf install -y xmonad
mkdir -p ../quantam/rootfs/usr/share/X11/xorg.conf.d
cp /usr/bin/xmonad ../quantam/rootfs/usr/bin/
sudo dnf remove -y xmonad

mkdir -p iso/boot/grub2
cp /boot/vmlinuz-6.10.2 iso/boot/vmlinuz
cp /boot/initramfs-6.10.2.img iso/boot/initramfs.img || true

cat > iso/boot/grub2/grub.cfg << EOF
set default=0
set timeout=5

menuentry "QuantamOS" {
    linux /boot/vmlinuz root=/dev/sr0
    initrd /boot/initramfs.img
}
EOF

grub2-mkrescue -o quantam.iso iso

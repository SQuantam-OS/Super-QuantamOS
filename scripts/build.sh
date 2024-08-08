#!/bin/bash
# GitHub did not allow me to merge my pull request so I am redoing all of the files
# QuantamOS build.sh fix
# BE ELEVATED WITH SUDO
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo! or else"
    exit 1
fi
start_time=$(date +%s)

cd ~/
git clone https://github.com/SQuantam-OS/qRoot
cd ~/qRoot

make menuconfig
make -j$(nproc)
cd output/images
mkdir -p ~/quantam
cp -R bzImage rootfs.ext4 ~/quantam/
cd ~/quantam/
mv rootfs.ext4 rootfs.tar
tar xf rootfs.tar
rm *.tar
cd rootfs
mkdir -p ~/quantam/rootfs/usr/local/bin
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
cd /usr/local/bin
sudo mv distrobox distrobox-enter distrobox-generate-entry distrobox-list distrobox-upgrade distrobox-assemble distrobox-ephemeral  distrobox-host-exec distrobox-rm distrobox-create  distrobox-export  distrobox-init distrobox-stop ~/quantam/rootfs/usr/local/bin
cd ~/quantam/rootfs/
find . | cpio -o --format=newc | gzip > ../initramfs.gz
mkdir -p ~/iso/boot/grub
cd ~/quantam
cp bzImage ~/iso/boot/vmlinuz
cp initramfs.gz ~/iso/boot/initramfs.gz

cat > iso/boot/grub/grub.cfg << EOF
set default=0
set timeout=5

menuentry "QuantamOS" {
    linux /boot/vmlinuz root=/dev/sr0
    initrd /boot/initramfs.gz
}
EOF

cd ~/
grub-mkrescue -o quantam.iso iso
end_time=$(date +%s)
build_time=$((end_time - start_time))
echo "Build finished. Time took to build: $build_time seconds/minutes.

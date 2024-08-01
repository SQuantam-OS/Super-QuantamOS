FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libncurses-dev \
        bison \
        flex \
        libssl-dev \
        libelf-dev \
        grub-pc-bin \
        grub-efi-amd64-bin \
        xorriso \
        ghc \
        cabal-install \
        libx11-dev \
        libxft-dev \
        libxinerama-dev \
        wget \
        xz-utils \
        bzip2 \
        grub2

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.2.tar.xz && \
    tar -xvf linux-6.10.2.tar.xz && \
    cd linux-6.10.2 && \
    make menuconfig && \
    make -j$(nproc) && \
    make modules_install && \
    make install && \
    cd ..

RUN [ ! -f /boot/vmlinuz-6.10.2 ] && echo "Kernel image not found! Exiting." && exit 1

RUN mkdir -p quantam/rootfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}

RUN wget https://busybox.net/downloads/busybox-1.33.1.tar.bz2 && \
    tar -xvf busybox-1.33.1.tar.bz2 && \
    cd busybox-1.33.1 && \
    make defconfig && \
    make -j$(nproc) && \
    make install CONFIG_PREFIX=../quantam/rootfs && \
    cd ..

RUN echo "::sysinit:/etc/init.d/rcS" > quantam/rootfs/etc/inittab && \
    mkdir -p quantam/rootfs/etc/init.d && \
    echo "#!/bin/sh" > quantam/rootfs/etc/init.d/rcS && \
    echo "mount -t proc none /proc" >> quantam/rootfs/etc/init.d/rcS && \
    echo "mount -t sysfs none /sys" >> quantam/rootfs/etc/init.d/rcS && \
    echo "/sbin/mdev -s" >> quantam/rootfs/etc/init.d/rcS && \
    chmod +x quantam/rootfs/etc/init.d/rcS

RUN apt-get install -y xmonad && \
    cp /usr/bin/xmonad quantam/rootfs/usr/bin/ && \
    apt-get remove -y xmonad

RUN mkdir -p iso/boot/grub && \
    cp /boot/vmlinuz-6.10.2 iso/boot/vmlinuz && \
    cp /boot/initramfs.gz iso/boot/initramfs.gz && \
    echo 'set default=0\nset timeout=5\n\nmenuentry "QuantamOS" {\n    linux /boot/vmlinuz root=/dev/sr0\n    initrd /boot/initramfs.gz\n}' > iso/boot/grub/grub.cfg && \
    grub-mkrescue -o quantam.iso iso

CMD [ "bash" ]

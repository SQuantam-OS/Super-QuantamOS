FROM debian:latest

RUN apt-get update && \
    apt-get install -y wget bzip2 libncurses-dev flex bison bc libelf-dev libssl-dev xz-utils autoconf gcc make libtool git vim libpng-dev libfreetype-dev g++ extlinux nano
    
WORKDIR /workspace

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.xz && \
    tar xf linux-6.10.tar.xz

WORKDIR /workspace/linux-6.10
RUN make menuconfig && \
    make -j $(nproc) && \
    mkdir /distro && \
    cp arch/x86/boot/bzImage /distro

WORKDIR /workspace
RUN wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2 && \
    tar xf busybox-1.36.1.tar.bz2

# Build and install BusyBox
WORKDIR /workspace/busybox-1.36.1
RUN make menuconfig && \
    make -j $(nproc) && \
    make CONFIG_PREFIX=/distro install
    
WORKDIR /workspace
RUN git clone https://github.com/ghaerr/microwindows.git && \
    cd microwindows/src && \
    cp Configs/config.linux-fb config && \
    sed -i 's/NX11=N/NX11=Y/' config && \
    make && \
    make install

WORKDIR /workspace
RUN truncate -s 200MB boot.img && \
    mkfs.ext2 boot.img && \
    mount -o loop boot.img mnt && \
    mkdir -p mnt/{var,etc,root,tmp,dev,proc} && \
    cp -r /distro/bin /distro/lib /distro/lib64 /distro/nanox /distro/linuxrc /distro/usr mnt && \
    umount mnt

RUN apt-get install -y qemu-system-x86

CMD ["/bin/bash"]

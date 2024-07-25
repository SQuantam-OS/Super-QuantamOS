apt install bzip2 libncurses-dev flex bison bc libelf-dev libssl-dev xz-utils autoconf gcc make libtool git vim libpng-dev libfreetype-dev g++ extlinux
echo "This script requires you to do things aswell"
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.xz
tar xf linux-6.10.tar.xz
echo "Enable These things when you are in a menuconfig : Device Drivers > Graphic support > Cirrus driver|Frame buffer devices > support for frame buffer devices|Bootup logo|mouse interface"
sleep 9
cd linux-6.10
make menuconfig
make -j 8
mkdir /distro
cp arch/x86/boot/bzImage /distro
wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
tar xf busybox-1.36.1.tar.bz2
cd busybox-1.36.1
echo "Enable : settings > build static library (No shared libs) (NEW) "
sleep 6
make -j 8
make CONFIG_PREFIX=/distro install
cd ..
git clone https://github.com/SQuantam-OS/microwindows-quantam
cd microwindows/src/
cp Configs/config.linux-fb config
make
make install
echo "Paste in any line of code that is C it can be hello world this is required"
mkdir x11
cd x11
nano gui.c
gcc gui.c -lNX11 -lnano-x
mv a.out /distro/x11app
cd bin/
ldd nano-X
mkdir /distro/lib/
mkdir /distro/lib64/
cp /lib/x86_64-linux-gnu/libpng16.so.16 /distro/lib/x86_64-linux-gnu/libpng16.so.16
cp /lib/x86_64-linux-gnu/libfreetype.so.6 /distro/lib/x86_64-linux-gnu/libfreetype.so.6
cp /lib/x86_64-linux-gnu/libc.so.6 /distro/lib/x86_64-linux-gnu/libc.so.6
cp /lib/x86_64-linux-gnu/libm.so.6 /distro/lib/x86_64-linux-gnu/libm.so.6
cp /lib/x86_64-linux-gnu/libbrotlidec.so.1 /distro/lib/x86_64-linux-gnu/libbrotlidec.so.1
cp /lib64/ld-linux-x86-64.so.2 /distro/lib64/ld-linux-x86-64.so.2
cp /lib/x86_64-linux-gnu/libbrotlicommon.so.1 /distro/lib/x86_64-linux-gnu/libbrotlicommon.so.1
cd ..
cp -r bin /distro/nanox
cp runapp /distro/nanox
cd /distro
truncate -s 200MB boot.img
mkfs boot.img
extlinux -i mnt
mv bin bzImage lib lib64 nanox/ x11app/ linuxrc usr/ mnt
cd mnt
mkdir var etc root tmp dev proc
echo "System Built"

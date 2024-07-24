# Super-QuantamOS
***Super-QuantamOS*** is a custom Linux distribution built from scratch using the [DFS](https://github.com/GuestSneezeOSDev/DFS) Project, designed specifically for gaming.
## How to build
follow the [DFS GUI](https://github.com/GuestSneezeOSDev/DFS/tree/main/GUI) Guide on how to build
## Building apps
```
mkdir -p /distro/mnt/usr/lib/x86_64-linux-gnu
cp /lib/x86_64-linux-gnu/libGL.so.1 /distro/mnt/usr/lib/x86_64-linux-gnu/
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
mkdir steam-deb
dpkg-deb -x steam.deb steam-deb/
mkdir -p /distro/mnt/usr/local/steam
cp -r steam-deb/opt/steam /distro/mnt/usr/local/steam
cp -r steam-deb/opt/steam /distro/mnt/usr/local/steam
ldd /distro/mnt/usr/local/steam/steam
echo 'export PATH=$PATH:/usr/local/steam' >> /distro/mnt/etc/profile
ln -s /usr/local/steam/steam /distro/mnt/usr/local/bin/steam
echo '/usr/local/steam/lib' > /distro/mnt/etc/ld.so.conf.d/steam.conf
ldconfig
```
after finishing use `boot.img` in a VM (keep the mnt folder) and boot it up from the Detailed DFS Guide
now steam should be runnable in SQOS
```
./usr/local/steam/steam
```



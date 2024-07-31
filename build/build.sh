# QuantamOS OS
# Soon I/GuestSneezeOSDev will make my own kernel meaning it will not be linux based (2 years)
sudo apt-get update
sudo apt-get install gcc g++ make libncurses5-dev libssl-dev bc
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.tar.xz
tar -xf linux-5.10.tar.xz
cd linux-5.10
make -j$(nproc)
make modules_install
make install

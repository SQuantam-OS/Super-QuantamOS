#!/bin/bash
# Maintainer : GuestSneezeOSDev
# Maintainer : LukeShortCloud
# Install wine-quantam
sudo apt-get update && apt install git
git clone https://github.com/SQuantam-OS/wine-Quantam.git
mv wine-Quantam /distro/mnt/etc/
# Tell User if wine finished porting
echo "Finished porting Wine"

#!/bin/sh
#we need two input parameters
npsbuildpath=$1
mkdir -p /NPS
rm -rf /NPS/*
mkdir -p /NPS/auto-deploy
chmod 777 /NPS/auto-deploy
pwd
mv ./ovinstallparams_nps.ini /var/tmp/ovinstallparams.ini
mkdir -p /NPS/keys
cp ./HPE-GPG-Public-Keys.zip /NPS/keys
cd /NPS/keys
chmod a+x *
unzip HPE-GPG-Public-Keys.zip
cd /NPS/keys/HPE-GPG-Public-Keys
chmod a+x *
./import.sh
cd /NPS/auto-deploy
wget -r -nd -np -l 1 -A "*.tar.gz" ${npsbuildpath}
chmod a+x *
#mkdir /build
#mount -o loop *.iso /build
tar -xvf *.tar.gz
#cd /build
./setup.bin -i silent

#BUILD_ID=DONTKILLME
/opt/OV/NNMPerformanceSPI/bin/startALL.ovpl
/opt/OV/NNMPerformanceSPI/bin/statusALL.ovpl
#!/bin/sh
#we need two input parameters
nnmibuildpath=$1
#buildID=$2
if [ -d "/opt/OV/Uninstall/NNM" ]; then  
	#cd /opt/ov/uninstall/NNM
	/opt/OV/Uninstall/NNM/setup.bin -i silent -uninstall
	rm -rf /opt/*
	rm -rf /var/opt/*
fi
mkdir -p /NNMi
rm -rf /NNMi/*
mkdir -p /NNMi/auto-deploy
chmod 777 /NNMi/auto-deploy
cp ./HPE-GPG-Public-Keys.zip /NNMi/auto-deploy
mkdir -p /NNMi/keys
mv /NNMi/auto-deploy/HPE-GPG-Public-Keys.zip /NNMi/keys
cd /NNMi/keys
unzip HPE-GPG-Public-Keys.zip
cd HPE-GPG-Public-Keys
chmod a+x *
./import.sh
cd /NNMi/auto-deploy
wget -r -nd -np -l 1 -A "N*.tar.gz" ${nnmibuildpath}
chmod a+x *
tar -xvf *.tar.gz
ls
#${buildID}=DONTKILLME
cp ./support/ovinstallparams.ini /tmp
./setup.bin -i silent
/opt/OV/bin/ovstart -v
/opt/OV/bin/ovstatus -v

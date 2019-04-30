#!/bin/sh
#we need two input parameters
nnmibuildpath=$1
db_type=$2
db_user=$3
#buildID=$2
#if [ -d "/opt/OV/Uninstall/NNM" ]; then  
	#cd /opt/ov/uninstall/NNM
#	/opt/OV/Uninstall/NNM/setup.bin -i silent -uninstall
#	rm -rf /opt/*
#	rm -rf /var/opt/*
#fi
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
if [ $(echo ${db_type:0:1}|tr [a-z] [A-Z]) = O ]; then
cp -f ${WORKSPACE}/ovinstallparams_oracle.ini /tmp
mv /tmp/ovinstallparams_oracle.ini /tmp/ovinstallparams.ini
sed -i "s/db.user.loginname.*$/db.user.loginname=${db_user}/g" /tmp/ovinstallparams.ini
chmod a+x /tmp/ovinstallparams.ini
elif [ $(echo ${db_type:0:1}|tr [a-z] [A-Z]) = E ]; then
cp -f ./support/ovinstallparams.ini /tmp
else
cp -f ./support/ovinstallparams.ini /tmp
fi
./setup.bin -i silent
/opt/OV/bin/ovstart -v
/opt/OV/bin/ovstatus -v

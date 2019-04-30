#!/bin/sh
trafficbuild=$1
trafficleaf=$2
if [ -d "/opt/OV/Uninstall/HPOvTRLiSPI" ]; then
	/opt/OV/Uninstall/HPOvTRLiSPI/setup.bin -i silent -uninstall
fi
mkdir -p /Traffic
rm -rf /Traffic/*
mkdir -p /Traffic/auto-deploy
chmod 777 /Traffic/auto-deploy
#cp ./silentInstallMaster.properties ./silentInstallExt.properties ./silentInstallLeaf.properties /Traffic/auto-deploy
cd /Traffic/auto-deploy
wget -r -nd -np -A "NMC-NNMi-Perf-Traffic-Lin*.tar.gz" ${trafficbuild}
#BUILD_ID=DONTKILLME
chmod a+x *
tar -xvf *.tar.gz
cp ./Traffic_Leaf/silentInstallLeaf.properties /tmp
sed -i "s/TRAFFIC.LEAF.FQDN.*$/TRAFFIC.LEAF.FQDN=${trafficleaf}/g" /tmp/silentInstallLeaf.properties
./Traffic_Leaf/Installer.Linux2.6_64/setup.bin -i silent
/opt/OV/traffic-leaf/bin/nmstrafficleafstart.ovpl
/opt/OV/traffic-leaf/bin/nmstrafficleafstatus.ovpl

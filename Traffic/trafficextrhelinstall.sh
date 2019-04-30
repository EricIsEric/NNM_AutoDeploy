#!/bin/sh
trafficbuild=$1
nnmihost=$2
if [ -d "/opt/OV/Uninstall/HPOvTENM" ]; then
	/opt/OV/Uninstall/HPOvTENM/setup.bin -i silent -uninstall
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
cp ./Traffic_NNM_Extension/silentInstallExt.properties /tmp
sed -i "s/TRAFFIC.MASTER.HOST.*$/TRAFFIC.MASTER.HOST = ${nnmihost}/g" /tmp/silentInstallExt.properties
/opt/OV/bin/ovstart -v
/opt/OV/bin/ovstatus -v
./Traffic_NNM_Extension/Linux/setup.bin -i silent
/opt/OV/bin/ovstart -v
/opt/OV/bin/ovstatus -v

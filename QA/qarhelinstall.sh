#!/bin/sh
qabuild=$1
if [ -d "/opt/OV/Uninstall/HPOvQAiSPI" ]; then
	/opt/OV/Uninstall/HPOvQAiSPI/setup.bin -i silent
fi
mkdir -p /QA
rm -rf /QA/*
mkdir -p /QA/auto-deploy
chmod 777 /QA/auto-deploy
cd /QA/auto-deploy
wget -r -nd -np -A "NMC-NNMi-Perf-QA-Lin*.tar.gz" ${qabuild}
chmod a+x *
tar -xvf *.tar.gz
cp ./silentInstall.properties /tmp
/opt/OV/bin/ovstart -v
./setup.bin -i silent
#BUILD_ID=DONTKILLME
#/opt/OV/bin/ovstatus -v
/opt/OV/bin/ovstart -c qajboss
/opt/OV/bin/ovstatus -v

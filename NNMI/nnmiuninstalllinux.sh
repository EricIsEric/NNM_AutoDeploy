#!/bin/sh
if [ -f "/opt/OV/Uninstall/NNM/setup.bin" ]; then
	/opt/OV/Uninstall/NNM/setup.bin -i silent
	if [ ! -f "/opt/OV/Uninstall/NNM/setup.bin" ]; then 
		rm -rf /opt/*
		rm -rf /var/opt/*
	fi
fi
#!/bin/sh
. ./roles/home-cli/files/profile
if [ $(uname -s) = FreeBSD ]
then
	INVENTORY=./inventories/freebsd.ini
else
	INVENTORY=./local.ini
fi
./user-gui.yml -i $INVENTORY

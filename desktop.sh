#!/bin/sh
. ./roles/home-cli/files/profile
if [ $(uname -s) = FreeBSD ]
then
	INVENTORY=./inventories/freebsd.ini
elif [ $(uname -s) = OpenBSD ]
then
	INVENTORY=./inventories/openbsd.ini
else
	INVENTORY=./local.ini
fi
./user-gui.yml -i $INVENTORY

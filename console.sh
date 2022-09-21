#!/bin/sh
. ./roles/home-cli/files/profile
if [ $(uname -s) = FreeBSD ]
then
	INVENTORY=./inventories/local-freebsd.ini
else
	INVENTORY=./inventories/local-linux.ini
fi
./user-cli.yml -i $INVENTORY

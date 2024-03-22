#!/bin/sh
. ./roles/home-cli/files/profile
./user-gui.yml -i ./inventories/$(uname -s).ini

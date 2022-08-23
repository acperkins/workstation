#!/bin/sh
. ./roles/home-cli/files/profile
./admin-gui.yml -K -i ./local.ini
./user-gui.yml -i ./local.ini

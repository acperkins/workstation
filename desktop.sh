#!/bin/sh
. ./roles/home-cli/files/bashrc
./admin-gui.yml -K -i ./local.ini
./user-gui.yml -i ./local.ini

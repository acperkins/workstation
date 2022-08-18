#!/bin/sh
. ./roles/home-cli/files/bashrc
./admin-cli.yml -K -i ./local.ini
./user-cli.yml -i ./local.ini

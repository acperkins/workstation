#!/bin/sh
. ./roles/home-cli/files/profile
./admin-cli.yml -K -i ./local.ini
./user-cli.yml -i ./local.ini

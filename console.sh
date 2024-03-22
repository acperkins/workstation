#!/bin/sh
. ./roles/home-cli/files/profile
./user-cli.yml -i ./inventories/$(uname -s).ini

#!/bin/sh
set -e
dnf groupinstall -y 'Development Tools'
dnf install -y ncurses-devel
./configure --prefix=${1:-/opt/vim} --disable-nls --disable-gui

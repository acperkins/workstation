#!/bin/sh
set -e
echo "Usage: $0 [install_dir] [vim_git_repo]"
vim_dir=$(mktemp -d -t vim-XXXXXXXXXXXX --tmpdir=/var/tmp)
dnf install -y @development-tools ncurses-devel
git clone ${2:-https://github.com/vim/vim.git} $vim_dir
pushd $vim_dir
./configure --prefix=${1:-/opt/vim} --disable-nls --disable-gui
make
make install
popd
rm -fr $vim_dir

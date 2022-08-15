#!/bin/bash

# Copyright 2021 Anthony Perkins
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ "x$1" == "x--help" ] || [ "x$1" == "x-h" ] || [ "x$1" == "x-?" ]
then
	echo "Usage: $0 [install_path] [bin_path]"
	exit
fi

install_path=${1:-/opt/ansible}
bin_path=${2:-/usr/local/bin}
echo "Install path:  $install_path"
echo "Bin path:      $bin_path"
echo "Press RETURN to continue, or Ctrl-C to cancel."
read

pipinstall () {
	if [ -r /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem ]; then
		cafile="--cert /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"
	else
		cafile=""
	fi
	./bin/pip $cafile install --upgrade $1
}

create_link () {
	ln -sf "$install_path/bin/$1" "$bin_path/$1"
}

py3cmd="$(command -v python3)"
if [ ! -x "$py3cmd" ]; then
	echo "python3 not found"
	exit 1
else
	echo "Python3 found: $py3cmd"
fi

if ! $($py3cmd -c "import venv" 2> /dev/null); then
	echo "Python3 venv module missing. Try installing python3-venv package."
	exit 1
fi

if ! $($py3cmd -c "import ensurepip" 2> /dev/null); then
	echo "Python3 ensurepip module missing. Try installing python3-venv package."
	exit 1
fi

if [ ! -d "$install_path" ]; then
	python3 -m venv "$install_path" || exit 1
fi

pushd "$install_path"
pipinstall wheel
pipinstall pip
pipinstall ansible
popd

if [ ! -d "$bin_path" ]; then
	mkdir "$bin_path"
fi

for command in \
	ansible \
	ansible-config \
	ansible-connection \
	ansible-console \
	ansible-doc \
	ansible-galaxy \
	ansible-inventory \
	ansible-playbook \
	ansible-pull \
	ansible-test \
	ansible-vault; do
	create_link $command
done

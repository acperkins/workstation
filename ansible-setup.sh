#!/bin/sh

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

pipinstall () {
	./bin/pip install --upgrade $1
}

create_link () {
	ln -sf "../opt/ansible/bin/$1" "$HOME/bin/$1"
}

py3cmd="$(command -v python3)"
if [ ! -x "$py3cmd" ]; then
	echo "python3 not found"
	return 1
else
	echo "python3 found: $py3cmd"
fi

if [ ! -x "$HOME/opt/ansible/bin/ansible-playbook" ]; then
	python3 -m venv "$HOME/opt/ansible"
fi

pushd "$HOME/opt/ansible"
pipinstall pip
pipinstall wheel
pipinstall ansible
popd

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

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

if [ ! -x "$HOME/opt/ansible/bin/ansible-playbook" ]; then
	python3 -m venv "$HOME/opt/ansible"
fi

pushd "$HOME/opt/ansible"
pipinstall pip
pipinstall wheel
pipinstall ansible
popd

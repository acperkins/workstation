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

if [ $(id -u) -eq 0 ]; then
	install_path=/opt/docutils
	bin_path=/usr/local/bin
else
	install_path="$HOME/opt/docutils"
	bin_path="$HOME/.local/bin"
fi

pipinstall () {
	./bin/pip install --upgrade $1
}

create_link () {
	ln -srf "$install_path/bin/$1.py" "$bin_path/$1"
}

py3cmd="$(command -v python3)"
if [ ! -x "$py3cmd" ]; then
	echo "python3 not found"
	return 1
else
	echo "python3 found: $py3cmd"
fi

if [ ! -d "$install_path" ]; then
	python3 -m venv "$install_path" || exit 1
fi

pushd "$install_path"
pipinstall wheel
pipinstall pip
pipinstall docutils
popd

if [ ! -d "$bin_path" ]; then
	mkdir "$bin_path"
fi

for output in \
	html4 \
	html5 \
	html \
	latex \
	man \
	odt_prepstyles \
	odt \
	pseudoxml \
	s5 \
	xetex \
	xml; do
	create_link rst2$output
done

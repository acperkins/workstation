#!/bin/bash

test -x /usr/bin/gsettings || (echo "gsettings not found" && exit 1)

set_favorites_bar () {
	local firefox
	if [ -r /usr/share/applications/firefox-esr.desktop ] && [ ! -r /usr/share/applications/firefox.desktop ]
	then
		firefox=firefox-esr
	else
		firefox=firefox
	fi
	gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', '$firefox.desktop']"
}
set_favorites_bar

set_keyboard_and_language () {
	local us="('xkb', 'us')"
	local ca="('xkb', 'ca+multix')"
	local layouts
	if [ "$(echo $LANG | sed 's/_.*//')" = "fr" ]
	then
		layouts="[$ca, $us]"
	else
		layouts="[$us, $ca]"
	fi
	gsettings set org.gnome.desktop.input-sources sources "$layouts"
}
set_keyboard_and_language

set_nautilus_preferences () {
	gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
	gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
	gsettings set org.gtk.Settings.FileChooser sort-directories-first 'true'
}
set_nautilus_preferences

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

	gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', '$firefox.desktop', 'code.desktop']"
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
	gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"
}
set_keyboard_and_language

set_nautilus_preferences () {
	gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
	gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
	gsettings set org.gtk.Settings.FileChooser sort-directories-first true
}
set_nautilus_preferences

set_gnome_terminal_preferences () {
	gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
	gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false
	gsettings set org.gnome.Terminal.Legacy.Settings shortcuts-enabled false
}
set_gnome_terminal_preferences

set_misc_preferences () {
	# Disable alert sounds.
	gsettings set org.gnome.desktop.sound event-sounds false

	# Turn off natural scrolling.
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

	# Configure the top bar and calendar.
	gsettings set org.gnome.desktop.interface clock-show-date true
	gsettings set org.gnome.desktop.interface clock-show-seconds false
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	gsettings set org.gnome.desktop.calendar show-weekdate true

	# Add minimise and maximise buttons to the window title bars.
	gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

	# Stop dialogue boxes from 'sticking' to their parent windows.
	gsettings set org.gnome.mutter attach-modal-dialogs false

	# Solid-colour background.
	gsettings set org.gnome.desktop.background picture-uri ''
	gsettings set org.gnome.desktop.background primary-color '#3a6ea5'
}
set_misc_preferences

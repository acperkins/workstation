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

	if [ -r ${XDG_CONFIG_HOME:-$HOME/.config}/favorite-apps.conf ]; then
		gsettings set org.gnome.shell favorite-apps "$(cat ${XDG_CONFIG_HOME:-$HOME/.config}/favorite-apps.conf)"
	else
		gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', '$firefox.desktop']"
	fi
}
set_favorites_bar

set_keyboard_and_language () {
	gsettings set org.gnome.desktop.input-sources show-all-sources true
	gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'gb')]"
	gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch', 'compose:caps', 'shift:both_capslock']"
	gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"

	# Set custom keybindings.
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/']"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ command '/usr/bin/gnome-terminal'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ name 'Launch Terminal'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ binding '<Primary><Alt>t'
}
set_keyboard_and_language

set_nautilus_preferences () {
	gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
	gsettings set org.gtk.Settings.FileChooser sort-directories-first true
}
set_nautilus_preferences

set_gnome_terminal_preferences () {
	gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false
	gsettings set org.gnome.Terminal.Legacy.Settings shortcuts-enabled false
}
set_gnome_terminal_preferences

set_gnome_extensions () {
	gnomeextcmd=/usr/bin/gnome-extensions
	if ! [ -x $gnomeextcmd ]
	then
		# gnome-extensions not installed.
		return
	fi
	# Disable all extensions.
	for ext in $gnomeextcmd list --enabled
	do
		$gnomeextcmd disable -q $ext
	done
}
set_gnome_extensions

set_misc_preferences () {
	# Disable alert sounds.
	gsettings set org.gnome.desktop.sound event-sounds false

	# Turn on natural scrolling.
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

	# Configure the top bar and calendar.
	gsettings set org.gnome.desktop.interface clock-show-date true
	gsettings set org.gnome.desktop.interface clock-show-seconds false
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	gsettings set org.gnome.desktop.calendar show-weekdate true

	# Remove minimise and maximise buttons from the window title bars.
	gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:close'

	# Stop dialogue boxes from 'sticking' to their parent windows.
	gsettings set org.gnome.mutter attach-modal-dialogs false

	# Disable hot-corners.
	gsettings set org.gnome.desktop.interface enable-hot-corners false

	# Set a background colour for when a wallpaper is not available.
	gsettings set org.gnome.desktop.background primary-color '#023c88'
	gsettings set org.gnome.desktop.background secondary-color '#5789ca'
	gsettings set org.gnome.desktop.background color-shading-type 'solid'
}
set_misc_preferences

if [ -x "$HOME/bin/reset-gnome-setup.local" ]
then
	. "$HOME/bin/reset-gnome-setup.local"
fi

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
	if [ x$LANG == xfr_FR.UTF-8 ]
	then
		gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'ca+multix'), ('xkb', 'us')]"
	else
		gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"
	fi
	gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch', 'compose:caps', 'nbsp:level3n', 'shift:both_capslock']"
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
	gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'

	defaultprofile="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/"
	gsettings set $defaultprofile background-color '#101010'
	gsettings set $defaultprofile default-size-columns 132
	gsettings set $defaultprofile default-size-rows 24
	gsettings set $defaultprofile foreground-color '#C0C0C0'
	gsettings set $defaultprofile palette "[
		'#000000', '#800000', '#008000', '#808000', '#000080', '#800080', '#008080', '#C0C0C0',
		'#808080', '#FF0000', '#00FF00', '#FFFF00', '#0000FF', '#FF00FF', '#00FFFF', '#FFFFFF'
	]"
	gsettings set $defaultprofile use-theme-colors false
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
	gsettings set org.gnome.desktop.calendar show-weekdate false

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

	# Configure fonts.
	gsettings set org.gnome.desktop.interface document-font-name 'Sans 11'
	gsettings set org.gnome.desktop.interface font-name 'Sans 11'
	gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 11'
	gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Sans Bold 11'

	# Always show the Accessibility menu.
	gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
}
set_misc_preferences

if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/reset-gnome-setup.local" ]
then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/reset-gnome-setup.local"
fi

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
	# Bash-specific test.
	if [[ "$(. /etc/os-release && echo ${ID:-none})" == rhel ]] || [[ "$(. /etc/os-release && echo ${ID_LIKE:-none})" == *rhel* ]]
	then
		dashtodock=dash-to-dock@gnome-shell-extensions.gcampax.github.com
	else
		dashtodock=dash-to-dock@micxgx.gmail.com
	fi
	for ext in $dashtodock appindicatorsupport@rgcjonas.gmail.com
	do
		$gnomeextcmd disable -q $ext
	done
}
set_gnome_extensions

set_dash_to_dock_preferences () {
	if gsettings list-keys org.gnome.shell.extensions.dash-to-dock 2>&1 >/dev/null; then
		# Reset all dash-to-dock settings.
		gsettings reset-recursively org.gnome.shell.extensions.dash-to-dock

		# Set my preferences, based on Ubuntu's default config (as of 21.10).
		gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#000000'
		gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 1.0
		gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'focus-or-previews'
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-customize-running-dots true
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-running-dots-border-color '#ffffff'
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-running-dots-color '#ffffff'
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink false
		gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
		gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
		gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
		gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
		gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
		gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'ALL_WINDOWS'
		gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
		gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DOTS'
		gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'switch-workspace'
		gsettings set org.gnome.shell.extensions.dash-to-dock shift-click-action 'launch'
		gsettings set org.gnome.shell.extensions.dash-to-dock shift-middle-click-action 'minimize'
		gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
		gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
		gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
		gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'

	fi
}
#set_dash_to_dock_preferences

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

	# Enable hot-corners.
	gsettings set org.gnome.desktop.interface enable-hot-corners true

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

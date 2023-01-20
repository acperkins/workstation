#!/bin/sh

test -x /usr/bin/gsettings || (echo "gsettings not found" && exit 1)

set_favorites_bar () {
    if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/favorite-apps.conf" ]
    then
        gsettings set org.gnome.shell favorite-apps "$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/favorite-apps.conf")"
    else
        gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'org.mozilla.firefox.desktop', 'org.keepassxc.KeePassXC.desktop']"
    fi
}
set_favorites_bar

set_keyboard_and_language () {
    gsettings set org.gnome.desktop.input-sources show-all-sources true
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ca+multix')]"
    gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch', 'lv5:rctrl_switch']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

    # Set custom keybindings.
    if [ -x /usr/bin/kgx ] && ! [ -x /usr/bin/gnome-terminal ]
    then
        _acp_term=/usr/bin/kgx
    else
        _acp_term=/usr/bin/gnome-terminal
    fi
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ command "$_acp_term"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ name 'Launch Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ binding '<Super>Return'
    unset _acp_term
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
    gsettings set "$defaultprofile" background-color '#101010'
    gsettings set "$defaultprofile" default-size-columns 132
    gsettings set "$defaultprofile" default-size-rows 24
    gsettings set "$defaultprofile" foreground-color '#C0C0C0'
    gsettings set "$defaultprofile" palette "[
        '#000000', '#800000', '#008000', '#808000', '#000080', '#800080', '#008080', '#C0C0C0',
        '#808080', '#FF0000', '#00FF00', '#FFFF00', '#0000FF', '#FF00FF', '#00FFFF', '#FFFFFF'
    ]"
    gsettings set "$defaultprofile" use-theme-colors false
}
set_gnome_terminal_preferences

set_gnome_text_editor_preferences () {
    if gsettings list-schemas | grep '^org.gnome.TextEditor$' > /dev/null
    then
        gsettings set org.gnome.TextEditor restore-session false
    fi
}
set_gnome_text_editor_preferences

set_gnome_extensions () {
    gnomeextcmd=/usr/bin/gnome-extensions
    if ! [ -x $gnomeextcmd ]
    then
        # gnome-extensions not installed.
        return
    fi
    # Disable all extensions.
    for ext in $($gnomeextcmd list --enabled)
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
    gsettings set org.gnome.desktop.interface clock-format '24h'
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.interface clock-show-seconds false
    gsettings set org.gnome.desktop.interface clock-show-weekday true
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
    gsettings reset org.gnome.desktop.interface font-name
    gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 11'
    gsettings reset org.gnome.desktop.wm.preferences titlebar-font

    # Always show the Accessibility menu.
    gsettings set org.gnome.desktop.a11y always-show-universal-access-status true

    # Set Gnome Clocks locations.
    # Vancouver, CA; Toronto, CA; Halifax, CA; London, GB; UTC; Paris, FR.
    gsettings set org.gnome.clocks world-clocks "[{'location': <(uint32 2, <('Vancouver', 'CYVR', true, [(0.85841109795478021, -2.1496638678574467)], [(0.85957465660720722, -2.1490820798045869)])>)>}, {'location': <(uint32 2, <('Toronto', 'CYTZ', true, [(0.76154532446909495, -1.3857914260834978)], [(0.76212711252195475, -1.3860823201099277)])>)>}, {'location': <(uint32 2, <('Halifax', 'CYHZ', true, [(0.78336194011902394, -1.1082840750163994)], [(0.77928951101546806, -1.1100294042683936)])>)>}, {'location': <(uint32 2, <('London', 'EGWU', true, [(0.89971722940307675, -0.007272211034407213)], [(0.89884456477707964, -0.0020362232784242244)])>)>}, {'location': <(uint32 2, <('Coordinated Universal Time (UTC)', '@UTC', false, @a(dd) [], @a(dd) [])>)>}, {'location': <(uint32 2, <('Paris', 'LFPB', true, [(0.85462956287765413, 0.042760566673861078)], [(0.8528842336256599, 0.040724343395436846)])>)>}]"
}
set_misc_preferences

if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/reset-gnome-setup.local" ]
then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/reset-gnome-setup.local"
fi

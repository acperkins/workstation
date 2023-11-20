#!/bin/sh

test -x /usr/bin/gsettings || (echo "gsettings not found" && exit 1)

set_favorites_bar () {
    local firefox
    if [ -r /usr/share/applications/firefox-esr.desktop ] && [ ! -r /usr/share/applications/firefox.desktop ]
    then
        firefox=firefox-esr
    else
        firefox=firefox
    fi
    if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/favorite-apps.conf" ]
    then
        gsettings set org.gnome.shell favorite-apps "$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/favorite-apps.conf")"
    else
        gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', '$firefox.desktop', 'org.keepassxc.KeePassXC.desktop']"
    fi
}
set_favorites_bar

set_keyboard_and_language () {
    gsettings set org.gnome.desktop.input-sources show-all-sources true
    gsettings set org.gnome.desktop.input-sources xkb-options "['compose:menu', 'lv3:ralt_switch', 'lv5:rctrl_switch']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

    case "$LANG" in
    "fr_FR.UTF-8")
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fr+afnor'), ('xkb', 'gb')]"
        ;;
    *)
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'gb'), ('xkb', 'fr+afnor')]"
        ;;
    esac

    # Set the thumb button on the Logitech MX Master mouse to 'toggle-overview'. Defaults are:
    #   gsettings set org.gnome.desktop.wm.keybindings switch-panels "['<Control><Alt>Tab']"
    #   gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "['<Shift><Control><Alt>Tab']"
    #   gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>s']"
    gsettings set org.gnome.desktop.wm.keybindings switch-panels "['']"
    gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "['']"
    gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>s', '<Control><Alt>Tab']"

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
    gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true
    gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
}
set_nautilus_preferences

set_gnome_terminal_preferences () {
    gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false
    gsettings set org.gnome.Terminal.Legacy.Settings shortcuts-enabled false
    gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'

    defaultprofile="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/"
    gsettings set "$defaultprofile" audible-bell false
    gsettings set "$defaultprofile" background-color '#101010'
    gsettings set "$defaultprofile" default-size-columns 132
    gsettings set "$defaultprofile" default-size-rows 24
    gsettings set "$defaultprofile" foreground-color '#C0C0C0'
    gsettings set "$defaultprofile" palette "[
        '#2E3436', '#CC0000', '#4E9A06', '#C4A000', '#3465A4', '#75507B', '#06989A', '#D3D7CF',
        '#555753', '#EF2929', '#8AE234', '#FCE94F', '#729FCF', '#AD7FA8', '#34E2E2', '#EEEEEC'
    ]"
    gsettings set "$defaultprofile" preserve-working-directory 'always'
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

    # Enable Tap to Click.
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'

    # Configure the top bar and calendar.
    gsettings set org.gnome.desktop.interface clock-format '24h'
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.interface clock-show-seconds false
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.calendar show-weekdate false

    # Remove minimise and maximise buttons from the window title bars.
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

    # Stop dialogue boxes from 'sticking' to their parent windows.
    gsettings set org.gnome.mutter attach-modal-dialogs false

    # Disable hot-corners.
    gsettings set org.gnome.desktop.interface enable-hot-corners false

    # Configure fonts.
    gsettings set org.gnome.desktop.interface document-font-name 'Berkeley Mono 10'
    gsettings set org.gnome.desktop.interface font-name 'Berkeley Mono 10'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Berkeley Mono 10'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Berkeley Mono Bold 10'

    # Always show the Accessibility menu.
    gsettings set org.gnome.desktop.a11y always-show-universal-access-status true

    # Set Gnome Clocks locations.
    # America/New_York; America/Halifax; Europe/London; Europe/Paris.
    gsettings set org.gnome.clocks world-clocks "[{'location': <(uint32 2, <('New York', 'KNYC', true, [(0.71180344078725644, -1.2909618758762367)], [(0.71059804659265924, -1.2916478949920254)])>)>}, {'location': <(uint32 2, <('Halifax', 'CYHZ', true, [(0.78336194011902394, -1.1082840750163994)], [(0.77928951101546806, -1.1100294042683936)])>)>}, {'location': <(uint32 2, <('London', 'EGWU', false, [(0.89971722940307675, -0.007272211034407213)], [(0.89971722940307675, -0.007272211034407213)])>)>}, {'location': <(uint32 2, <('Paris', 'LFPB', true, [(0.85462956287765413, 0.042760566673861078)], [(0.8528842336256599, 0.040724343395436846)])>)>}]"

    # Enable Night Light.
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled 'true'
    gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic 'true'

    # Remove the wallpaper.
    gsettings set org.gnome.desktop.background color-shading-type 'solid'
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    gsettings set org.gnome.desktop.background picture-uri "file://$XDG_DATA_HOME/wallpaper.svg"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$XDG_DATA_HOME/wallpaper.svg"
    gsettings set org.gnome.desktop.background primary-color '#101010'
    gsettings set org.gnome.desktop.background secondary-color '#101010'

    # Prefer the dark theme.
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

    # Reset the app picker layout. Will take effect after a gnome-shell restart
    # (log off and on again).
    gsettings reset org.gnome.shell app-picker-layout
}
set_misc_preferences

if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/reset-gnome-setup.local" ]
then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/reset-gnome-setup.local"
fi

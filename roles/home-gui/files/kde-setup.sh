#!/bin/sh

# Plasma.
plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
if [ -r "$XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc.acp" ]
then
    rm -f "$XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc"
    cp "$XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc.acp" "$XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc"
fi
kwriteconfig5 --file kdeglobals --group KDE --key SingleClick false
kwriteconfig5 --file kwinrc --group NightColor --key Active true
kwriteconfig5 --file kwinrc --group Desktops --key Number 4
kwriteconfig5 --file kwinrc --group Desktops --key Rows 2

# Keyboard.
kwriteconfig5 --file kxkbrc --group Layout --key Use true
kwriteconfig5 --file kxkbrc --group Layout --key Model pc105
kwriteconfig5 --file kxkbrc --group Layout --key LayoutList gb,ca
kwriteconfig5 --file kxkbrc --group Layout --key VariantList ,multix
kwriteconfig5 --file kxkbrc --group Layout --key DisplayNames ,
kwriteconfig5 --file kxkbrc --group Layout --key Options grp:win_space_toggle,compose:menu,lv3:ralt_switch,lv5:rctrl_switch

# Konsole.
kwriteconfig5 --file konsolerc --group KonsoleWindow --key RememberWindowSize false

# Dolphin.
kwriteconfig5 --file dolphinrc --group General --key RememberOpenedTabs false
kwriteconfig5 --file dolphinrc --group DetailsMode --key PreviewSize 16
kwriteconfig5 --file dolphinrc --group DetailsMode --key ExpandableFolders false

# Klipper.
kwriteconfig5 --file klipperrc --group General --key KeepClipboardContents false

# KeePassXC.
kwriteconfig5 --file keepassxc/keepassxc.ini --group GUI --key ApplicationTheme classic
kwriteconfig5 --file keepassxc/keepassxc.ini --group SSHAgent --key Enabled true

# Restart some applications.
qdbus org.kde.KWin /KWin reconfigure
qdbus org.kde.plasmashell /PlasmaShell refreshCurrentShell

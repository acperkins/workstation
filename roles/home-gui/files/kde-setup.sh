#!/bin/sh

# Plasma.
plasma-apply-colorscheme BreezeDark
plasma-apply-cursortheme breeze_cursors
plasma-apply-desktoptheme default
plasma-apply-wallpaperimage "$XDG_DATA_HOME/wallpaper.svg"
kwriteconfig5 --file kdeglobals --group KDE --key SingleClick false
kwriteconfig5 --file kwinrc --group NightColor --key Active true
kwriteconfig5 --file kwinrc --group Desktops --key Id_1 16b2b027-cd5a-48fa-9bd5-c1f0f4f9e550
kwriteconfig5 --file kwinrc --group Desktops --key Id_2 7afe0a12-0cf6-4953-8aed-811d5de9470d
kwriteconfig5 --file kwinrc --group Desktops --key Id_3 189f8351-0229-483b-a249-ca7d27be44bd
kwriteconfig5 --file kwinrc --group Desktops --key Id_4 9a917386-5b9b-4181-854f-ef0eb45151b3
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
qdbus org.kde.plasmashell /PlasmaShell refreshCurrentShell

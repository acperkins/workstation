#!/bin/sh

plasma-apply-lookandfeel --apply org.kde.breezedark.desktop --resetLayout
kwriteconfig5 --file "$XDG_CONFIG_HOME/konsolerc" --group KonsoleWindow --key RememberWindowSize --type bool false

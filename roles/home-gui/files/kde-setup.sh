#!/bin/sh

plasma-apply-lookandfeel --apply org.kde.breezedark.desktop --resetLayout
kwriteconfig5 --file konsolerc --group KonsoleWindow --key RememberWindowSize --type bool false

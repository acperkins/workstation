#!/bin/sh

# Get X11 working by disabling 'socket=fallback-x11' with Flatseal.
#
# Force single-monitor working by changing 'use multimon:i:1' to
# 'use multimon:i:0' in the .rdpw file.

/usr/bin/flatpak run \
    --command=xfreerdp \
    com.freerdp.FreeRDP \
    /w:1600 /h:900 \
    /dynamic-resolution \
    $*

#!/bin/sh

# Change variables below if needed.
TARGET_USER=acp
TARGET_GROUP=$TARGET_USER
TARGET_DIR="/$TARGET_USER"

# Create root directory. Fail if it cannot be created.
install -d -m 700 -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR || exit 1

# Create subdirectories.
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/bin
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/doc
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/etc
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/lib
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/include
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/man
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/share
install -d -o $TARGET_USER -g $TARGET_GROUP $TARGET_DIR/src

# Set up symlinks.
ln -s ../man $TARGET_DIR/share/man

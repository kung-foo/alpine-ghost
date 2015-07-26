#!/usr/bin/env sh
set -e

# create required directories
mkdir -p user-content/themes user-content/data user-content/images user-content/apps

# make sure the default theme exists
if [ ! -h user-content/themes/casper ]; then
    ln -s content/themes/casper user-content/themes/casper
fi

chown -R ghost:ghost user-content/*

# boo
exec gosu ghost npm start --production

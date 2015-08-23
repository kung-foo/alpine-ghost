#!/usr/bin/env sh
set -e

[ ! -z "$DEBUG" ] && set -ex

# create required directories
mkdir -p user-content/themes user-content/data user-content/images user-content/apps

# make sure the default theme exists
if [ ! -h user-content/themes/casper ]; then
	ln -s content/themes/casper user-content/themes/casper
fi

chown -R ghost:ghost user-content/*

if [ "$GHOST_STORE" = "postgres" ]; then
	echo "Waiting for postgres to come up..."
	waitforit -k -r 60 "postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB"
fi

# boo
echo "Starting Ghost $GHOST_VER..."
exec gosu ghost npm start --production

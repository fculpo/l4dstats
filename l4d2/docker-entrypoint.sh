#!/bin/bash
set -e

if [ "$1" = 'l4d2' ]; then
  # Create appid if necessary
  if [ ! -e /opt/steam/l4d2/steam_appid.txt ]; then
    echo 550 >  /opt/steam/l4d2/steam_appid.txt
  fi
  
  # Take ownership on possible mounted volumes
  chown -R steam:steam /opt/steam/l4d2/left4dead2/addons
  
  # Launch server as steam user
  exec gosu steam /opt/steam/l4d2/srcds_run -game left4dead2 +map c4m1_milltown_a
fi

# Launch command if provided (as root)
exec "$@"

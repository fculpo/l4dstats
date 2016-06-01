#!/bin/bash
set -e

if [ "$1" = 'l4d2' ]; then
  chown -R steam /opt/steam/
  exec gosu steam /opt/steam/l4d2/srcds_run -game left4dead2 -usercon -ip 0.0.0.0
fi

exec "$@"

#!/bin/sh

chown -R nginx /usr/share/webapps/

exec "$@"

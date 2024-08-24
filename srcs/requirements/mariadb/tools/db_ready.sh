#!/bin/sh

mariadb --skip-ssl --skip-ssl-verify-server-cert \
	-h localhost --protocol tcp  -e 'select 1' 2>&1 | grep -qF "Can't connect"

if (( "$ret" == 0 )); then
		# grep Matched "Can't connect" so we fail
		connect_s=1
	else
		connect_s=0
	fi

return $connect_s

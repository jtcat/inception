#!/bin/bash

DATADIR="/var/lib/mysql"

chown mysql:mysql ${DATADIR}

SOCKET="/run/mysqld/mysqld.sock"

exec_client() {
	mariadb --protocol=socket -u root -h localhost --socket="${SOCKET}" "$@"
}

mariadb-install-db --datadir=${DATADIR} --auth-root-authentication-method=normal \
	--skip-test-db \
	--old-mode='UTF8_IS_UTF8MB3' \
	--default-time-zone=SYSTEM --enforce-storage-engine= \
	--skip-log-bin \
	--expire-logs-days=0 \
	--loose-innodb_buffer_pool_load_at_startup=0 \
	--loose-innodb_buffer_pool_dump_at_shutdown=0

mkdir /run/mysqld

chown -R mysql:mysql /run/mysqld

mariadbd -u root --skip-networking --default-time-zone=SYSTEM --socket="${SOCKET}" --wsrep_on=OFF \
	--expire-logs-days=0 \
	--loose-innodb_buffer_pool_load_at_startup=0 \
	--skip-ssl \
	&

sql_escape_string_literal() {
	local newline=$'\n'
	local escaped=${1//\\/\\\\}
	escaped="${escaped//$newline/\\n}"
	echo "${escaped//\'/\\\'}"
}

for i in {30..0}; do
	if exec_client --database=mysql \
		--skip-ssl --skip-ssl-verify-server-cert \
		<<<'SELECT 1' &> /dev/null; then
			break
	fi
	sleep 1
done

rootPasswordEscaped=$(sql_escape_string_literal "$(cat ${MARIADB_ROOT_PASSWORD_FILE})")
userPasswordEscaped=$(sql_escape_string_literal "$(cat ${MARIADB_PASSWORD_FILE})")

exec_client <<-ESQL
	-- Securing system users shouldn't be replicated
	SET @orig_sql_log_bin= @@SESSION.SQL_LOG_BIN;
	SET @@SESSION.SQL_LOG_BIN=0;
    -- we need the SQL_MODE NO_BACKSLASH_ESCAPES mode to be clear for the password to be set
	SET @@SESSION.SQL_MODE=REPLACE(@@SESSION.SQL_MODE, 'NO_BACKSLASH_ESCAPES', '');

	DROP USER IF EXISTS root@'127.0.0.1', root@'::1';
	EXECUTE IMMEDIATE CONCAT('DROP USER IF EXISTS root@\'', @@hostname,'\'');

	CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY '${rootPasswordEscaped}' ;
	GRANT ALL ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION ;
	GRANT PROXY ON ''@'%' TO 'root'@'127.0.0.1' WITH GRANT OPTION;
	-- end of securing system users, rest of init now...
	SET @@SESSION.SQL_LOG_BIN=@orig_sql_log_bin;
	-- create users/databases
	CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\`;
	CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '${userPasswordEscaped}' ;
	GRANT ALL ON \`${MARIADB_DATABASE//_/\\_}\`.* TO '$MARIADB_USER'@'%';
ESQL

MARIADB_PID=$!

kill "$MARIADB_PID"
wait "$MARIADB_PID"

exec mariadbd -u root --skip-networking=false --port=3306

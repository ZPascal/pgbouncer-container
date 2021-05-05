#!/bin/sh
# Based on https://raw.githubusercontent.com/mbentley/dockerfiles/master/ubuntu/pgbouncer/run.sh

set -e

PG_PORT_5432_TCP_ADDR=${PG_PORT_5432_TCP_ADDR:-}
PG_PORT_5432_TCP_PORT=${PG_PORT_5432_TCP_PORT:-}
PG_ENV_POSTGRESQL_USER=${PG_ENV_POSTGRESQL_USER:-}
PG_ENV_POSTGRESQL_PASS=${PG_ENV_POSTGRESQL_PASS:-}
PG_ENV_POSTGRESQL_MAX_CLIENT_CONN=${PG_ENV_POSTGRESQL_MAX_CLIENT_CONN:-}
PG_ENV_POSTGRESQL_DEFAULT_POOL_SIZE=${PG_ENV_POSTGRESQL_DEFAULT_POOL_SIZE:-}
PG_ENV_POSTGRESQL_SERVER_IDLE_TIMEOUT=${PG_ENV_POSTGRESQL_SERVER_IDLE_TIMEOUT:-}
PG_ENV_POSTGRESQL_POOL_MODE=${PG_ENV_POSTGRESQL_POOL_MODE:-}

if [ ! -f /etc/pgbouncer/pgbconf.ini ]
then
cat << EOF > /etc/pgbouncer/pgbconf.ini
[databases]
* = host=${PG_PORT_5432_TCP_ADDR} port=${PG_PORT_5432_TCP_PORT}
[pgbouncer]
logfile = /var/log/pgbouncer/pgbouncer.log
pidfile = /var/run/pgbouncer/pgbouncer.pid
;listen_addr = *
listen_addr = 0.0.0.0
listen_port = 6432
unix_socket_dir = /var/run/pgbouncer
;auth_type = any
auth_type = trust
;admin_users = ${PG_ENV_POSTGRESQL_USER}
stats_users = ${PG_ENV_POSTGRESQL_USER}
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = ${PG_ENV_POSTGRESQL_POOL_MODE}
server_reset_query = DISCARD ALL
max_client_conn = ${PG_ENV_POSTGRESQL_MAX_CLIENT_CONN}
default_pool_size = ${PG_ENV_POSTGRESQL_DEFAULT_POOL_SIZE}
ignore_startup_parameters = extra_float_digits
server_idle_timeout = ${PG_ENV_POSTGRESQL_SERVER_IDLE_TIMEOUT}
EOF
fi

if [ ! -s /etc/pgbouncer/userlist.txt ]
then
        echo '"'"${PG_ENV_POSTGRESQL_USER}"'" "'"${PG_ENV_POSTGRESQL_PASS}"'"'  > /etc/pgbouncer/userlist.txt
fi

chmod 640 /etc/pgbouncer/userlist.txt

pgbouncer -u postgres /etc/pgbouncer/pgbconf.ini
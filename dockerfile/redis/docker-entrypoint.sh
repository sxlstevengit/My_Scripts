#!/bin/sh
set -e

set_arg(){
  echo never > "/sys/kernel/mm/transparent_hugepage/enabled"
  echo 511 > "/proc/sys/net/core/somaxconn"
}

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
        set_arg
        set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
        set_arg
        find . \! -user redis -exec chown redis '{}' +
        exec su-exec redis "$0" "$@"
fi

exec "$@"

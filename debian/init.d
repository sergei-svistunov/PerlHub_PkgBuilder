#!/bin/bash

### BEGIN INIT INFO
# Provides:          perlhub_pkg_builder
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts wordstat's daemons
# Description:       starts wordstat's daemons using start-stop-daemon
### END INIT INFO

DIR=/var/run/perlhub_pkg_builder

PATH=/bin:/usr/bin:/sbin:/usr/sbin

DAEMON=/usr/bin/perlhub_pkg_builder
ARGS="--workers=20"
PIDFILE=$DIR/perlhub_pkg_builder.pid

trap "" 1
export PATH

case "$1" in
  start)
    echo "Starting perlhub_pkg_builder"
    mkdir -p $DIR
    start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON -- $ARGS --daemonize --pid=$PIDFILE
    ;;

  stop)
    echo "Stopping FastCGI"
    start-stop-daemon --stop --pidfile $PIDFILE --oknodo --retry 5
    ;;

  restart)
    $0 fcgi_stop
    $0 fcgi_start
    exit $?
    ;;

  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart}"
    exit 1
    ;;
esac

if [ $? == 0 ]; then
  echo OK
  exit 0
else
  echo Failed
  exit 1
fi

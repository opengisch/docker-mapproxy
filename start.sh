#!/bin/bash

if [[ -f /uwsgi.conf ]]; then
  rm /uwsgi.conf
fi;
cat > /uwsgi.conf <<EOF
[uwsgi]
chdir = /io/config
pyargv = /mapproxy.yaml
wsgi-file = /io/mapproxy/app.py
pidfile=/var/run/mapproxy.pid
http = 0.0.0.0:8080
processes = $PROCESSES
cheaper = 2
threads = $THREADS
master = true
req-logger = file:/var/log/uwsgi-requests.log
logger = file:/var/log/uwsgi-errors.log
memory-report = true
harakiri = 60
chmod-socket = 777
EOF

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"/..

mapproxy-util serve-develop -b 0.0.0.0:8080 /io/config/mapproxy.yaml

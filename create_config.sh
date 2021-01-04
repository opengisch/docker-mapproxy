#!/bin/bash

DIR=/io/config

USER_ID=$(stat -c '%u' "$DIR")
GROUP_ID=$(stat -c '%g' "$DIR")
USER_NAME=$(stat -c '%U' "$DIR")

groupadd -g "$GROUP_ID" mapproxy
useradd --shell /bin/bash --uid "$USER_ID" --gid "$GROUP_ID" "$USER_NAME"

# Create a default mapproxy config is one does not exist in /mapproxy
if [ ! -f /io/config/mapproxy.yaml ]
then
  su "$USER_NAME" -c "mapproxy-util create -t base-config /io/config/mapproxy"
fi
mkdir -p /io/app

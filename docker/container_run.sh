#!/bin/bash

echo "ffmpeg `ffmpeg -version`"

USER_ID=${LOCAL_USER_ID:-1000}
GROUP_ID=${LOCAL_GROUP_ID:-1000}

echo "Starting with UID=$USER_ID and GID=$GROUP_ID"
groupadd -g $GROUP_ID -o rubyapp
useradd --shell /bin/bash -u $USER_ID -o -c "" -g $GROUP_ID rubyapp
chown -R rubyapp:rubyapp /rubyapp
cd /rubyapp

chroot --userspec rubyapp:rubyapp / /rubyapp/docker/chroot_run.sh

#!/bin/bash
/rubyapp/docker/prepare_env.sh
chown -R rubyapp:rubyapp /rubyapp
cd /rubyapp
chroot --userspec rubyapp:rubyapp / /rubyapp/docker/chroot_run.sh

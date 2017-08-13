#!/usr/bin/dumb-init /bin/bash
source /rubyapp/docker/prepare_env.sh
chown -R rubyapp:rubyapp /rubyapp
chroot --userspec rubyapp:rubyapp / /bin/bash -c "cd /rubyapp && bundle exec ./bin/metador-worker 2>&1"

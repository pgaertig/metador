#!/bin/bash
THIS_DIR=`dirname "$0"`
RUBYAPP_DIR=`readlink -f "${THIS_DIR}/../"`
echo "Adding /rubyapp-test with mount to $RUBYAPP_DIR (read-only)"
docker build --pull $RUBYAPP_DIR -f $THIS_DIR/docker/Dockerfile -t metador-test:latest
docker run --rm -it \
           -v $RUBYAPP_DIR:/rubyapp-test:ro \
           -v $RUBYAPP_DIR/../../kp-test-files:/rubyapp-test-files:ro \
           -v $RUBYAPP_DIR/../../kp-test-files/generated:/rubyapp-test-files/generated \
           --hostname=metador-test \
           -e LOCAL_USER_ID=$(id --group) -e LOCAL_USER_ID=$(id --user) \
           --entrypoint=/rubyapp-test/test/docker/prepare_test_env.sh metador-test:latest

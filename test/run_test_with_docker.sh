#!/bin/bash
set -e
TEST_DIR=`dirname "$0"`
RUBYAPP_DIR=`readlink -f "${TEST_DIR}/../"`
echo "Adding /rubyapp-test with mount to $RUBYAPP_DIR (read-only)"
docker build -t pgaertig/metador:latest $RUBYAPP_DIR
docker build $RUBYAPP_DIR -f $TEST_DIR/docker/Dockerfile -t metador-test:latest
docker run --rm -it \
           -v $RUBYAPP_DIR:/rubyapp-test:ro \
           -v $RUBYAPP_DIR/../../kp-test-files:/rubyapp-test-files:ro \
           -v $RUBYAPP_DIR/../../kp-test-files/generated:/rubyapp-test-files/generated \
           --hostname=metador-test \
           -e LOCAL_USER_ID=$(id --group) -e LOCAL_USER_ID=$(id --user) \
           --entrypoint=/rubyapp-test/test/docker/prepare_test_env.sh metador-test:latest

#!/bin/bash
SCRIPT_DIR=`dirname "$0"`
docker build $SCRIPT_DIR/.. -f $SCRIPT_DIR/../Dockerfile -t metador:latest

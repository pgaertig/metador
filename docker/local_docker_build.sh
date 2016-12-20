#!/bin/bash
THIS_DIR=`dirname "$0"`
docker build $THIS_DIR/.. -f $THIS_DIR/../Dockerfile -t metador:latest

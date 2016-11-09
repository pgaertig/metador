#!/bin/bash
docker run -it --rm -v /mnt:/mnt -e CONFIG=/mnt/config.yml -e CONFIG_ENV=production --net=host metador:latest


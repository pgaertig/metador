#!/bin/bash
docker run -d --hostname metador-t1 -v /mnt:/mnt -e CONFIG=/mnt/config.yml --name metador-t1 --net=host metador:latest
sleep 5
docker logs metador-t1


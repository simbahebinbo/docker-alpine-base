#!/bin/bash

#启动docker

docker run -d -v /tmp/alpine-base-`date +'%Y%m%d%H%M%S'`:/home/jovyan/logs -p 9050:9050 -t lansheng228/alpine-base:latest
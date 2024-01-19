#!/bin/bash

#停掉正在运行的docker容器


docker stop $(docker ps -qa --filter ancestor=lansheng228/alpine-base)
docker rm $(docker ps -qa --filter ancestor=lansheng228/alpine-base)
docker ps -a

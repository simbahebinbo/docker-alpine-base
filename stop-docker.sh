#!/bin/bash

#停掉正在运行的docker容器

docker ps -a
docker stop alpine-example
docker rm alpine-example

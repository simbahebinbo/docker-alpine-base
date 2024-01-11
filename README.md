项目部署说明


构建镜像

$ sudo docker build . -t alpine-example


启动镜像:

$ sudo docker run -d -v /tmp/alpine-example-`date +'%Y%m%d%H%M%S'`:/data/logs -p 9050:9050 -t alpine-example:latest



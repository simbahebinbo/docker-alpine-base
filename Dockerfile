FROM alpine:3.19.0

USER root

#将系统默认源替换为阿里云的源
RUN /bin/sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' /etc/apk/repositories

# install console
RUN apk add --no-cache bash tzdata ttf-dejavu supervisor

# Set the timezone
# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
ENV  TIME_ZONE Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# Configure environment
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

#定义常用变量
ARG SHELL=/bin/bash
ARG NB_USER=jovyan
ARG NB_UID=1000
ARG USER_HOME=/home/$NB_USER
ARG LOG_DIR=/data/logs

#创建用户
RUN adduser -s ${SHELL} -D -u ${NB_UID} ${NB_USER}

#创建日志目录
RUN /bin/mkdir -m 777 -p ${LOG_DIR}

USER ${NB_USER}

##添加源码
ADD source ${USER_HOME}/

USER root

#添加守护进程配置文件
RUN /bin/mkdir /etc/supervisor.d/
ADD example.ini /etc/supervisor.d/

VOLUME ${LOG_DIR}
EXPOSE 9050
ENTRYPOINT ["sh", "-c", "/usr/bin/supervisord --nodaemon"]

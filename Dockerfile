FROM alpine:3.19.0

USER root

#将系统默认源替换为阿里云的源
RUN /bin/sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' /etc/apk/repositories

# install console 时区 字体
RUN apk add --no-cache bash tzdata ttf-dejavu supervisor

#install 权限
RUN apk add --no-cache sudo

# install 编辑器
RUN apk add --no-cache vim

#
RUN apk add --no-cache tini

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
ARG NB_PASSWORD=123456
ARG NB_UID=1000
ARG USER_HOME=/home/${NB_USER}
ARG LOG_DIR=${USER_HOME}/logs

# Create jovyan user with UID=1000 and in the 'users' group
#用户名 jovyan  密码:123456
RUN adduser -D -s ${SHELL} -u ${NB_UID} -G wheel ${NB_USER}
RUN echo "${NB_USER}:${NB_PASSWORD}" | chpasswd

#sudo时免密
RUN echo "jovyan  ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/jovyan


#使用 普通用户
USER ${NB_USER}

# Setup jovyan home directory
RUN /bin/mkdir ${USER_HOME}/.local

#进入到工作目录
WORKDIR ${USER_HOME}


#创建日志目录
RUN /bin/mkdir -m 777 -p ${LOG_DIR}

##添加源码
ADD source ${USER_HOME}/
RUN sudo chmod +x ${USER_HOME}/noexit.sh && sudo chgrp wheel ${USER_HOME}/noexit.sh && sudo chown ${NB_USER} ${USER_HOME}/noexit.sh

#添加保持运行状态的脚本，用于调试
RUN sudo chmod +x ${USER_HOME}/idle.sh && sudo chgrp wheel ${USER_HOME}/idle.sh && sudo chown ${NB_USER} ${USER_HOME}/idle.sh


#添加守护进程配置文件
RUN sudo /bin/mkdir -p /etc/supervisor.d/
ADD example.ini /etc/supervisor.d/

VOLUME ${LOG_DIR}
EXPOSE 9050
ENTRYPOINT exec sudo /usr/bin/supervisord --nodaemon

#用于调试
#ENTRYPOINT exec /sbin/tini -- /home/jovyan/idle.sh

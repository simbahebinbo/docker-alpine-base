FROM alpine:3.7

#将系统默认源替换为阿里云的源
RUN /bin/sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' /etc/apk/repositories

ENV LANG zh_CN.UTF-8

# install console
RUN apk add --no-cache bash tzdata ttf-dejavu supervisor

# Set the timezone
# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
ENV  TIME_ZONE Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

#添加守护进程配置文件
RUN /bin/mkdir /etc/supervisor.d/
ADD example.ini /etc/supervisor.d/

##添加源码
ADD source /mnt/

#创建日志目录
ARG log_dir=/data/logs
RUN /bin/mkdir -p ${log_dir}
VOLUME ${log_dir}

EXPOSE 9050
ENTRYPOINT ["sh", "-c", "/usr/bin/supervisord --nodaemon"]





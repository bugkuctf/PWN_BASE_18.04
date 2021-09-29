FROM ubuntu:18.04
MAINTAINER bugku "root@bugku.com"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
COPY _files /root/
ADD start.sh /root/

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt update && \
    apt-get install -y netcat git && \
    apt install -y vim xinetd lib32z1

WORKDIR /home/
RUN useradd -m ctf

RUN cp -R /lib* /home/ctf && \
    cp -R /usr/lib* /home/ctf

COPY ./bin/ /home/ctf/

RUN chmod 700 /root/*.sh \
    && chmod +x /root/*.sh && \
#chroot必须环境
    mkdir /home/ctf/dev && \
    mknod /home/ctf/dev/null c 1 3 && \
    mknod /home/ctf/dev/zero c 1 5 && \
    mknod /home/ctf/dev/random c 1 8 && \
    mknod /home/ctf/dev/urandom c 1 9 && \
    chmod 666 /home/ctf/dev/* && \
#必要bin
    mkdir /home/ctf/bin && \
    cp /bin/sh /home/ctf/bin && \
    cp /bin/ls /home/ctf/bin && \
    cp /bin/cat /home/ctf/bin && \
    cp /bin/bash /home/ctf/bin && \
    cp /bin/nc /home/ctf/bin && \
    cp /usr/bin/git /home/ctf/bin && \
#配置文件自定义
    mv -f /root/ctf.xinetd /etc/xinetd.d/ctf && \
    echo "FAIL: BUGKUCTF.AWD" > /etc/banner_fail && \
#pwn之权限
    chown -R root:ctf /home/ctf && \
    chmod -R 755 /home/ctf && \
    chmod +x /home/ctf/pwn

EXPOSE 9999

ENTRYPOINT sh -c /root/start.sh

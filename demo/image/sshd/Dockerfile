FROM debian:stretch

ARG DIST=squeeze
ENV DEBIAN_FRONTEND noninteractive

ENV http_proxy=http://http-proxy.cezdata.corp:8080 \
    https_proxy=http://http-proxy.cezdata.corp:8080

RUN printf 'Acquire::http::Proxy "http://http-proxy.cezdata.corp:8080";\n\
Acquire::https::Proxy "http://http-proxy.cezdata.corp:8080";'\
    >/etc/apt/apt.conf.d/00_proxy

RUN cat /etc/apt/apt.conf.d/00_proxy

RUN apt-get -q update && apt-get install -y \
        openssh-server \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  mkdir -p /etc/ssh/keys && chmod 700 /etc/ssh/keys \
     && mkdir -p /run/sshd \
     && ssh-keygen -A

COPY files/sshd_init.sh /usr/local/bin/
COPY files/entrypoint.sh /
COPY files/motd /etc/motd
COPY files/sshd_config /etc/ssh

VOLUME ["/etc/ssh/keys"]
EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

LABEL version="0.1"

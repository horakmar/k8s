FROM docker-registry.cezdata.corp/ubuntu:16.04
MAINTAINER Martin Horak (horak.martin@gmail.com)
LABEL version="0.4"

# HERE comes proxy settings if building behind proxy.
COPY conf/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy
ENV HTTP_PROXY=http-proxy.cezdata.corp:8080
ENV HTTPS_PROXY=http-proxy.cezdata.corp:8080

RUN apt-get update && apt-get install -y curl

RUN curl 'https://download.ceph.com/keys/release.asc' | apt-key add -

RUN echo 'deb http://download.ceph.com/debian-luminous/ xenial main' >/etc/apt/sources.list.d/ceph.list

RUN apt-get update && apt-get install -y \
    bind9-host \
    ceph-common \
    dnsutils \
    git \
    iproute2 \
    iputils-ping \
    man \
    mc \
    mariadb-client \
    net-tools \
    netcat \
    postgresql-client \
    smbclient \
    socat \
    tcpdump \
    traceroute \
    vim \
    wget \
&& rm -rf /var/lib/apt/lists/*

RUN rm -f /core

COPY conf/pki/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# HERE comes proxy settings if building remotely.

COPY conf/sleep_forever.sh /

ENTRYPOINT ["/sleep_forever.sh"]

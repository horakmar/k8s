FROM quay.io/coreos/hyperkube:v1.8.4_coreos.0
MAINTAINER Martin Horak (horak.martin@gmail.com)

# HERE comes proxy settings if building locally
#COPY conf/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy
COPY conf/download.ceph.com.gpg.key /tmp/download.ceph.com.gpg.key

RUN apt-key add /tmp/download.ceph.com.gpg.key

RUN echo 'deb http://download.ceph.com/debian-luminous/ jessie main' >/etc/apt/sources.list.d/ceph.list
RUN apt-get update && apt-get upgrade -y \
        ceph-common \
&& rm -rf /var/lib/apt/lists/*

COPY conf/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy

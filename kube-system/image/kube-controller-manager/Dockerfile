FROM ubuntu:16.04

ARG KUBERNETES_VERSION=v1.9.2

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    KUBERNETES_DOWNLOAD_ROOT=https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64 \
    KUBERNETES_COMPONENT=kube-controller-manager

# HERE comes proxy settings if building locally
COPY conf/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy

COPY conf/download.ceph.com.gpg.key /tmp/download.ceph.com.gpg.key
RUN apt-key add /tmp/download.ceph.com.gpg.key
RUN echo 'deb http://download.ceph.com/debian-luminous/ xenial main' >/etc/apt/sources.list.d/ceph.list

RUN set -x \
    && apt-get update \
    && apt-get install -y curl

RUN HTTPS_PROXY=http://http-proxy.cezdata.corp:8080 HTTP_PROXY=http://http-proxy.cezdata.corp:8080 curl -L ${KUBERNETES_DOWNLOAD_ROOT}/${KUBERNETES_COMPONENT} -o /usr/bin/${KUBERNETES_COMPONENT} \
    && chmod +x /usr/bin/${KUBERNETES_COMPONENT}

RUN set -x \
    && apt-get install -y ceph-common \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

LABEL version="v1.9.2.0"

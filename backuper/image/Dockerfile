FROM docker.io/ubuntu:16.04

# HERE comes proxy settings if building behind proxy.
ENV http_proxy=http://http-proxy.cezdata.corp:8080 \
    https_proxy=http://http-proxy.cezdata.corp:8080
COPY files/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy

RUN apt-get -q update \
    && apt-get -y install curl \
                          kmod \
                          openssh-client \
                          vim \
    && curl -sL http://download.ceph.com/keys/release.asc | apt-key add - \
    && echo "deb http://download.ceph.com/debian-luminous/ xenial main" > /etc/apt/sources.list.d/ceph.list \
    && apt-get -q update \
    && apt-get -y install ceph-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN curl --noproxy corp -sLOOOO http://repo1.oos.svc.kube5.corp/tsm/amd64.deb/{gskcrypt64_8.0-50.66.linux.x86_64.deb,gskssl64_8.0-50.66.linux.x86_64.deb,tivsm-api64.amd64.deb,tivsm-ba.amd64.deb}

RUN dpkg -i gskcrypt64_8.0-50.66.linux.x86_64.deb gskssl64_8.0-50.66.linux.x86_64.deb
RUN dpkg -i tivsm-api64.amd64.deb
RUN dpkg -i tivsm-ba.amd64.deb

RUN rm *.deb

RUN curl --noproxy corp -sLo /usr/local/bin/kubectl http://repo1.oos.svc.kube5.corp/kubernetes/latest/kubectl \
    && chmod +x /usr/local/bin/kubectl

COPY files/dsm.* /opt/tivoli/tsm/client/ba/bin/
COPY files/TSM.PWD /etc/adsm/
COPY files/backup_dokuwiki.sh /usr/local/bin/
COPY files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/backup_dokuwiki.sh"]

LABEL version="0.5"
LABEL maintainer="Martin Horak (horak.martin@gmail.com)"

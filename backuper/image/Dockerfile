FROM docker.io/ubuntu:16.04

# HERE comes proxy settings if building behind proxy.
ENV http_proxy=http://http-proxy.cezdata.corp:8080 \
    https_proxy=http://http-proxy.cezdata.corp:8080
COPY files/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy

RUN apt-get -q update \
    && apt-get -y install curl \
                          vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

# TSM installation
RUN curl --noproxy corp -sLOOOO http://repo1.oos.svc.kube5.corp/tsm/amd64.deb/{gskcrypt64_8.0-50.66.linux.x86_64.deb,gskssl64_8.0-50.66.linux.x86_64.deb,tivsm-api64.amd64.deb,tivsm-ba.amd64.deb}

RUN dpkg -i gskcrypt64_8.0-50.66.linux.x86_64.deb gskssl64_8.0-50.66.linux.x86_64.deb \
    && dpkg -i tivsm-api64.amd64.deb \
    && dpkg -i tivsm-ba.amd64.deb \
    && rm *.deb

COPY files/dsm.* /opt/tivoli/tsm/client/ba/bin/
COPY files/TSM.PWD /etc/adsm/
COPY files/entrypoint.sh /
COPY files/sleep_forever.sh /usr/local/bin/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/sleep_forever.sh"]

LABEL version="0.6"
LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL name="backuper-tsm"
LABEL description="Basic TSM image"

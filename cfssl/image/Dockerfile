FROM docker.io/debian:stretch-slim
MAINTAINER Martin Horak <horak.martin@gmail.com>

COPY conf/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy
# ENV HTTP_PROXY=http-proxy.cezdata.corp:8080
# ENV HTTPS_PROXY=http-proxy.cezdata.corp:8080

RUN apt-get -y update \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       curl \
       ca-certificates \
    && HTTPS_PROXY=http-proxy.cezdata.corp:8080 curl -o /usr/local/bin/multirootca -SL https://pkg.cfssl.org/R1.2/multirootca_linux-amd64 \
    && chmod +x /usr/local/bin/multirootca \
    && apt-get remove -y --purge --auto-remove curl ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

RUN mkdir -p /etc/multirootca

ENTRYPOINT ["/usr/local/bin/multirootca"]
CMD ["-l", "primary", "-roots", "/etc/multirootca/conf/roots.conf"]

EXPOSE 8888

LABEL version="1.2.0"

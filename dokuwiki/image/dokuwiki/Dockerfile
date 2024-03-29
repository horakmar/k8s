FROM docker.io/alpine:3.7

ARG NGINX_UID=101
ARG NGINX_GID=101
ARG DOKU_UID=1200
ARG DOKU_GID=1200

# HERE comes proxy settings if building behind proxy.
ENV HTTP_PROXY=http://http-proxy.cezdata.corp:8080
ENV HTTPS_PROXY=http://http-proxy.cezdata.corp:8080

RUN addgroup -g ${NGINX_UID} nginx \
  && addgroup -g ${DOKU_GID} dokuwiki \
  && adduser -u ${NGINX_UID} -G nginx -s /sbin/nologin -D nginx \
  && adduser -u ${DOKU_UID} -G dokuwiki -s /sbin/nologin -D dokuwiki

RUN apk add --update --no-cache \
  nginx \
  php7-apcu \
  php7-common \
  php7-fpm \
  php7-gd \
  php7-intl \
  php7-ldap \
  php7-mbstring \
  php7-mysqlnd \
  php7-openssl \
  php7-pdo \
  php7-pdo_sqlite \
  php7-session \
  php7-xml \
  php7-zlib \
  supervisor \
  tini \
  wget

COPY conf/nginx.conf /etc/nginx
COPY conf/php-fpm.conf /etc/php7
COPY conf/supervisord.conf /etc
COPY conf/dokuwiki-run.sh /

ENV INSTALL=0

VOLUME ["/data"]
VOLUME ["/etc/nginx/pki"]

EXPOSE 80
ENTRYPOINT ["/sbin/tini", "--"]
CMD /dokuwiki-run.sh

LABEL version="0.8"
LABEL maintainer="Martin Horak (horak.martin@gmail.com)"

# Fix nignx UID 100 -> 101
# RUN sed -i "/nginx/ s/:100:/:101:/" /etc/passwd

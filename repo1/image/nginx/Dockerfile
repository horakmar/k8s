FROM docker.io/nginx:1.13-alpine

MAINTAINER Martin Horak (horak.martin@gmail.com)

RUN mkdir -p /etc/nginx/pki

COPY conf/ca-cezict1.pem /etc/nginx/pki
COPY conf/repo1.pem /etc/nginx/pki
COPY conf/repo1-key.pem /etc/nginx/pki

COPY conf/ssl.conf /etc/nginx/conf.d

# Fix nignx UID 100 -> 101
RUN sed -i "/nginx/ s/:100:/:101:/" /etc/passwd

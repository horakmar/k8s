FROM docker.io/nginx:1.13-alpine
MAINTAINER Martin Horak (horak.martin@gmail.com)
LABEL version="1.13-alpine.3"

COPY conf/ssl.conf /etc/nginx/conf.d

# Fix nignx UID 100 -> 101
RUN sed -i "/nginx/ s/:100:/:101:/" /etc/passwd

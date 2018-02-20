FROM docker.io/nginx:1.13-alpine
LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL version="1.13-alpine.4"

COPY conf/ssl.conf /etc/nginx/conf.d
COPY conf/default.conf /etc/nginx/conf.d

# Fix nginx UID 100 -> 101
RUN sed -i "/nginx/ s/:100:/:101:/" /etc/passwd

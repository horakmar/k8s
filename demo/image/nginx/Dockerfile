FROM docker.io/nginx:alpine

# Set nginx UID and GID to 501
RUN sed -i "/^nginx/ s/:x:[0-9]\+:[0-9]\+:/:x:501:501:/" /etc/passwd
RUN sed -i "/^nginx/ s/:x:[0-9]\+:/:x:501:/" /etc/group

COPY files/nginx.conf /etc/nginx/
COPY files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx"]

LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL version="0.3"

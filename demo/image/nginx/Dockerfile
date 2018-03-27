FROM docker.io/nginx:alpine

# Fix nginx UID 100 -> 101
RUN sed -i "/nginx/ s/:100:/:101:/" /etc/passwd

COPY files/nginx.conf /etc/nginx/
COPY files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx"]

LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL version="0.2"

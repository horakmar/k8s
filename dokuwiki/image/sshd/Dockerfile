FROM docker.io/alpine:3.7

LABEL version="0.1"
LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL description="Sidecar container for freeze/unfreeze FS. Connection via SSH."

ARG CMD_UID=101
ARG CMD_GID=101

# HERE comes proxy settings if building behind proxy.
ENV HTTP_PROXY=http://http-proxy.cezdata.corp:8080
ENV HTTPS_PROXY=http://http-proxy.cezdata.corp:8080

RUN addgroup -g ${CMD_GID} cmd \
  && adduser -u ${CMD_UID} -G cmd -g "Remote commands" -s /bin/sh -h /home/cmd -D cmd \
  && echo "cmd:*" | chpasswd -e

RUN apk add --update --no-cache \
  openssh-server \
  sudo \
  util-linux

COPY files/sshd_config /etc/ssh/
COPY files/sudoers /etc/
COPY files/entrypoint.sh / 


RUN ssh-keygen -b 2048 -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key

VOLUME ["/data"]
VOLUME ["/etc/ssh/keys"]

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-De"]

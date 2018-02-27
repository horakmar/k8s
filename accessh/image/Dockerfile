FROM docker-registry.cezdata.corp/ubuntu:16.04

# HERE comes proxy settings if building behind proxy.
COPY files/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy
#ENV HTTP_PROXY=http-proxy.cezdata.corp:8080
#ENV HTTPS_PROXY=http-proxy.cezdata.corp:8080

RUN apt-get -q update && apt-get -q install -y curl

RUN apt-get update && apt-get install -y \
    git \
    iproute2 \
    iputils-ping \
    man \
    mc \
    net-tools \
    netcat \
    openssh-server \
    smbclient \
    socat \
    sudo \
    tcpdump \
    traceroute \
    vim \
&& rm -rf /var/lib/apt/lists/*

RUN curl --noproxy corp -sLo /usr/local/bin/kubectl http://repo1.oos.svc.kube5.corp/kubernetes/latest/kubectl \
    && chmod +x /usr/local/bin/kubectl

COPY files/pki/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN rm -f /core
RUN mkdir -p /etc/ssh \
    && ssh-keygen -A

COPY files/motd /etc/motd
COPY files/admins.sudo /etc/sudoers.d/admins
COPY files/.bashrc /etc/skel/.bashrc
COPY files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL version="0.1"

FROM docker-registry.cezdata.corp/ubuntu:16.04

# HERE comes proxy settings if building behind proxy.
COPY files/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy
ENV HTTP_PROXY=http-proxy.cezdata.corp:8080
ENV HTTPS_PROXY=http-proxy.cezdata.corp:8080

RUN apt-get -q update && apt-get -q install -y \
        apt-transport-https \
        bash-completion \
        ca-certificates \
        curl \
        git \
        host \
        iproute2 \
        iputils-ping \
        jq \
        make \
        man \
        mc \
        net-tools \
        netcat \
        openssh-server \
        screen \
        smbclient \
        socat \
        software-properties-common \
        sudo \
        tcpdump \
        traceroute \
        vim

RUN curl --noproxy corp -sLo /usr/local/bin/kubectl http://repo1.oos.svc.kube5.corp/kubernetes/latest/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" >/etc/apt/sources.list.d/docker.list

RUN apt-get -q update && apt-get -q install -y \
        docker-ce \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN systemctl disable docker

COPY files/pki/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN rm -f /core

COPY files/ssh_host_keys/* /etc/ssh/
COPY files/motd /etc/motd
COPY files/admins.sudo /etc/sudoers.d/admins
COPY files/.bashrc /etc/skel/.bashrc
COPY files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

LABEL maintainer="Martin Horak (horak.martin@gmail.com)"
LABEL version="0.4"

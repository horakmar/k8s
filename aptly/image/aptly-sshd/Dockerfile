FROM docker-registry.cezdata.corp/aptly

RUN apt-get -q update \
    && apt-get install -y \
	    augeas-tools \
		openssh-server \
		screen \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  mkdir -p /etc/ssh/authkeys && chmod 700 /etc/ssh/authkeys \
     && augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile "/etc/ssh/authkeys/%u"' \
     && augtool 'set /files/etc/ssh/sshd_config/HostKey[1] /etc/ssh/keys/ssh_host_rsa_key' \
     && echo "Port 22" >> /etc/ssh/sshd_config \
     && mkdir -p /run/sshd \
     && mkdir -p /etc/ssh/keys \
     && ssh-keygen -A \
     && mv /etc/ssh/ssh_host_* /etc/ssh/keys/

COPY files/*.sh /usr/local/bin/
COPY files/entrypoint.sh /entrypoint.sh
COPY files/motd /etc/motd

VOLUME ["/var/lib/aptly", "/etc/ssh/authkeys"]
EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

LABEL version="0.3"

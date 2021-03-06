FROM debian:stretch

ARG DIST=squeeze
ENV DEBIAN_FRONTEND noninteractive

COPY files/apt_proxy.conf /etc/apt/apt.conf.d/00_proxy
ENV http_proxy=http://http-proxy.cezdata.corp:8080 \
    https_proxy=http://http-proxy.cezdata.corp:8080

# Install aptly and required tools
RUN apt-get -q update                     \
    && apt-get -y install bash-completion \
                          bzip2           \
                          gnupg1          \
                          gpgv            \
                          graphviz        \
                          wget            \
                          xz-utils        \
                          gosu            \
                          ubuntu-archive-keyring \
    && echo "deb http://repo.aptly.info/ $DIST main" > /etc/apt/sources.list.d/aptly.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9E3E53F19C7DE460 \
    && apt-get update \
    && apt-get -y install aptly \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable Aptly Bash completions
RUN wget https://raw.githubusercontent.com/smira/aptly/master/bash_completion.d/aptly \
  -O /etc/bash_completion.d/aptly \
  && echo "if ! shopt -oq posix; then\n\
  if [ -f /usr/share/bash-completion/bash_completion ]; then\n\
    . /usr/share/bash-completion/bash_completion\n\
  elif [ -f /etc/bash_completion ]; then\n\
    . /etc/bash_completion\n\
  fi\n\
fi" >> /etc/bash.bashrc
RUN echo 'PS1="\u@aptly-repo:\w\\\$ "' >>/etc/bash.bashrc

COPY files/aptly.conf /etc/aptly.conf
COPY files/*.sh /usr/local/bin/
COPY files/entrypoint.sh /entrypoint.sh
COPY files/proxy.env /etc/profile.d/proxy.sh

VOLUME ["/var/lib/aptly"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "1000000"]

LABEL version="0.3"

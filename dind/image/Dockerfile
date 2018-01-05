FROM docker:stable-dind
MAINTAINER Martin Horak (horak.martin@gmail.com)

COPY conf/ca-cezict1.pem /usr/local/share/ca-certificates/cezict1
COPY conf/cez_external_20211025.pem /usr/local/share/ca-certificates/cez_ext
COPY conf/cez_internal_20211025.pem /usr/local/share/ca-certificates/cez_int
COPY conf/cez_root_20250611.pem /usr/local/share/ca-certificates/cez_root

RUN update-ca-certificates

# Add docker-ls from https://github.com/mayflower/docker-ls
COPY conf/docker-ls-linux-amd64.zip /tmp
RUN unzip /tmp/docker-ls-linux-amd64.zip -d /usr/local/bin && rm /tmp/docker-ls-linux-amd64.zip

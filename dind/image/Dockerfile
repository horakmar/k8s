FROM docker:stable-dind
LABEL maintainer="Martin Horak (horak.martin@gmail.com)"

COPY conf/ca-cezict1.pem /usr/local/share/ca-certificates/cezict1.crt
COPY conf/cez_external_20211025.pem /usr/local/share/ca-certificates/cez_ext.crt
COPY conf/cez_internal_20211025.pem /usr/local/share/ca-certificates/cez_int.crt
COPY conf/cez_root_20250611.pem /usr/local/share/ca-certificates/cez_root.crt

RUN update-ca-certificates

# Add docker-ls from https://github.com/mayflower/docker-ls
COPY conf/docker-ls-linux-amd64.zip /tmp
RUN unzip /tmp/docker-ls-linux-amd64.zip -d /usr/local/bin && rm /tmp/docker-ls-linux-amd64.zip

FROM docker:stable-dind
MAINTAINER Martin Horak (horak.martin@gmail.com)

COPY conf/ca-kube1.pem /usr/local/share/ca-certificates/kube1
COPY conf/ca-cezict1.pem /usr/local/share/ca-certificates/cezict1
COPY conf/cez_external_20211025.pem /usr/local/share/ca-certificates/cez_ext
COPY conf/cez_internal_20211025.pem /usr/local/share/ca-certificates/cez_int
COPY conf/cez_root_20250611.pem /usr/local/share/ca-certificates/cez_root

RUN update-ca-certificates

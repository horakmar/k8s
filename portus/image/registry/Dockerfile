FROM library/registry:2

COPY files/cez_external_20211025.pem /usr/local/share/ca-certificates/cez_ext.crt
COPY files/cez_internal_20211025.pem /usr/local/share/ca-certificates/cez_int.crt
COPY files/cez_root_20250611.pem /usr/local/share/ca-certificates/cez_root.crt

RUN update-ca-certificates

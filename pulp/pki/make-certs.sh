#!/usr/bin/env bash

CERTS=certs
ORG=pulp

mkdir -p $(CERTS)

##### Create httpd cert
object=httpd

cfssl gencert -config config.json -profile server $(object).json | cfssljson -bare $(CERTS)/$(object)
mv $(CERTS)/$(object).pem $(CERTS)/$(object).crt
mv $(CERTS)/$(object)-key.pem $(CERTS)/$(object).key

##### Create mongodb cert
object=mongodb

cfssl gencert -config config.json -profile server $(object).json | cfssljson -bare $(CERTS)/$(object)
mv $(CERTS)/$(object).pem $(CERTS)/$(object).crt
mv $(CERTS)/$(object)-key.pem $(CERTS)/$(object).key
cat $(CERTS)/$(object).key $(CERTS)/$(object).crt > $(CERTS)/$(object).pem


##### Create generic client cert
object=client

cfssl gencert -config config.json -profile client $(object).json | cfssljson -bare $(CERTS)/$(object)
mv $(CERTS)/$(object).pem $(CERTS)/$(object).crt
mv $(CERTS)/$(object)-key.pem $(CERTS)/$(object).key
cat $(CERTS)/$(object).key $(CERTS)/$(object).crt > $(CERTS)/$(object).pem


##### Create qpid cert and DB

./pulp-qpid-ssl-cfg


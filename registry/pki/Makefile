all:
	echo "Usage:\n     make (dockerauth|registry)\n"

dockerauth registry:
	cfssl gencert -config config.json -profile server $@.json | cfssljson -bare $@
	kubectl create secret tls $@ --key $@-key.pem --cert $@.pem


all:
	echo "Usage:\n\n    make gencert; make kubesecret\n"

gencert:
	cfssl gencert -config config.json -profile server registry.json | cfssljson -bare registry

kubesecret:
	kubectl create secret tls registry-tls --key registry-key.pem --cert registry.pem

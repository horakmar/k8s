all:
	echo "Usage:\n\n    make gencert; make kubesecret\n"

gencert:
	cfssl gencert -config config.json -profile server registry.json | cfssljson -bare registry

kubesecret:
	kubectl create secret tls caplan-kibana-tls --key node-key.pem --cert node.pem

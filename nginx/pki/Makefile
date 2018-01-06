objects = repo1.pem

all:
	echo "Usage:\n\n    make gencert; make kubesecret\n"

gencert: $(objects)

$(objects): %.pem: %.json
	cfssl gencert -config config.json -profile server $< | cfssljson -bare $*

kubesecret:
	kubectl create secret tls caplan-kibana-tls --key node-key.pem --cert node.pem

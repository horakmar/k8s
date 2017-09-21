gencert:
	cfssl gencert -config config.json -profile server node.json | cfssljson -bare node

kubesecret:
	kubectl create secret tls caplan-kibana-tls --key node-key.pem --cert node.pem

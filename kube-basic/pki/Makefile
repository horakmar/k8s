OBJ = dashboard

gencrt:
	cfssl gencert -config config.json -profile server $(OBJ).json | cfssljson -bare $(OBJ)
	mv $(OBJ)-key.pem $(OBJ).key
	mv $(OBJ).pem $(OBJ).crt

gensecret:
	rm -rf cert
	mkdir -p cert
	cp dashboard.crt dashboard.key cert
	kubectl create secret generic kubernetes-dashboard-certs --from-file=./cert -n kube-system

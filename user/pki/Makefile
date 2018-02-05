object = admin-z

creds: $(object).crt $(object).key

$(object).crt: $(object).pem
	mv $(object).pem $(object).crt
	mv $(object)-key.pem $(object).key

$(object).pem: %.pem: %.json
	cfssl gencert -config config.json -profile client $< | cfssljson -bare $*

addcfg: $(object).crt
	kubectl config --kubeconfig config set-credentials $(object) --client-key=./$(object).key --client-certificate=./$(object).crt --embed-certs=true

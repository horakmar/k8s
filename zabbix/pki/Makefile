object = zabbix1

gencsr:
	cfssl genkey $(object).json | cfssljson -bare $(object)
	mv $(object)-key.pem $(object).key

sign:
	# Use CEZ ICT CA
	cat $(object).csr

dhparam.pem:
	openssl dhparam -dsaparam -out dhparam.pem 4096

gensecret: dhparam.pem
	-cp $(object).key ssl.key
	-cp $(object).crt ssl.crt
	kubectl -n oos create secret generic zabbix-web-tls --from-file=./ssl.key --from-file=./ssl.crt --from-file=./dhparam.pem

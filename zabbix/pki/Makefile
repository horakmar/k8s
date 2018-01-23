object = zabbix1

gencsr:
	cfssl genkey $(object).json | cfssljson -bare $(object)
	mv $(object)-key.pem $(object).key

dhparam.pem:
	openssl dhparam -dsaparam -out dhparam.pem 4096

gensecret: dhparam.pem
	-cp $(object).key ssl.key
	-cp $(object).crt ssl.crt
	kubectl create secret generic zabbix-web-tls --from-file=./ssl.key --from-file=./ssl.crt --from-file=./dhparam.pem

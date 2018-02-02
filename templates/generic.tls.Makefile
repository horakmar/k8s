object = repo1

gencsr:
	cfssl genkey $(object).json | cfssljson -bare $(object)
	mv $(object)-key.pem $(object).key
	@cat $(object).csr
	@echo
	@echo "Use CEZ ICT CA, save as $(object).crt"

gensecret: $(object).key $(object).crt
	rm -rf tmp
	mkdir -p tmp
	cp $(object).key tmp/ssl.key
	cp $(object).crt tmp/ssl.crt
	kubectl -n oos create secret generic repo1-tls --from-file=./tmp
	rm -rf tmp

object = repo1

gencsr:
	cfssl genkey $(object).json | cfssljson -bare $(object)
	mv $(object)-key.pem $(object).key
	@cat $(object).csr
	@echo
	@echo "Use CEZ ICT CA, save as $(object).crt"

gensecret: $(object).key $(object).crt
	kubectl -n oos create secret tls $(object)-tls --key $(object).key --cert $(object).crt

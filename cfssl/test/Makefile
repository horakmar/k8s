object = test1

$(object).crt:
	cfssl gencert -config=config.json -profile=peer $(object).json | cfssljson -bare $(object)
	mv $(object)-key.pem $(object).key
	mv $(object).pem $(object).crt

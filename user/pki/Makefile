objects = bso-admin.pem

gencert: $(objects)

$(objects): %.pem: %.json
	cfssl gencert -config config.json -profile client $< | cfssljson -bare $*

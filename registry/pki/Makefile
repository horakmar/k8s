auth = docker-auth.pem
reg = docker-registry.pem
bundle = docker-auth-bundle.pem
ca = ca-cezict1.pem

all: $(auth) $(reg) $(bundle)

$(auth) $(reg): %.pem: %.json
	cfssl gencert -config config.json -profile server $< | cfssljson -bare $*
	kubectl -n oos create secret tls $* --key $*-key.pem --cert $*.pem

$(bundle): $(auth) $(ca)
	cat $^ >$@

confmap: $(bundle)
	kubectl -n oos create configmap docker-auth-bundle --from-file $<


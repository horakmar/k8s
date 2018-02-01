gencsr:
	cfssl genkey dokuwiki.json | cfssljson -bare dokuwiki
	mv dokuwiki-key.pem dokuwiki.key

gensecret:
	kubectl create secret generic dokuwiki-web-tls --from-file=./dokuwiki.key --from-file=./dokuwiki.crt

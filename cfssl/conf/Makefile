roots:
	kubectl -n oos create cm cfssl-roots --from-file roots.conf

ca-files:
	kubectl -n oos create secret generic cfssl-ca-files  --from-file ./files

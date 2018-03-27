genkeys:
	cat keys/* >nginx.pub
	kubectl create cm ssh-keys --from-file=nginx.pub
	rm -f nginx.pub

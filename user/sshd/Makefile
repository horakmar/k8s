gencm:
	-rm -rf tmp
	mkdir tmp
	cp keys/* tmp
	cat keys/* >tmp/aptly
	cat keys/* >tmp/root
	kubectl -n oos create configmap ssh-keys-unixadm --from-file=tmp
	rm -rf tmp

all: servercert.pem

cakey.pem:
	(umask 277 && certtool --generate-privkey > $@)

cacert.pem: cakey.pem
	certtool --generate-self-signed \
		--template ca_template.info \
		--load-privkey $< \
		--outfile $@

serverkey.pem:
	(umask 277 && certtool --generate-privkey > $@)

servercert.pem: serverkey.pem cacert.pem cakey.pem
	certtool --generate-certificate \
		--template server_template.info \
		--load-privkey $< \
		--load-ca-certificate $(word 2,$^) \
		--load-ca-privkey $(word 3,$^) \
		--outfile $@

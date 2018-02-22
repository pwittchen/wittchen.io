all: clean generate update_docs run
install: protect_secrets
	sudo npm install --unsafe-perm
	echo "install finished"
theme:
	cd themes/custom && sudo npm install && gulp
	echo "theme build finished"
protect_secrets:
	npm run protect-secrets
	echo "secrets are safe"
expose_secrets:
	npm run expose-secrets
	echo "secrets ARE NOT SAFE"
run:
	echo "starting server..."
	hexo server
server: run
generate:
	hexo generate
deploy:
	echo "starting deployment..."
	hexo generate && ftpsync
	echo "deployment is done"
discard:
	git checkout -- source
	git clean -f source
docs:
	mkdir docs
	docsify init docs
update_docs:
	cp README.md docs
clean_docs:
	rm -rf docs
run_docs:
	docsify serve docs
clean:
	rm -rf public

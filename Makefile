install: protect-secrets
	sudo npm install --unsafe-perm
	echo "install finished"
theme:
	cd themes/custom && sudo npm install && gulp
	echo "theme build finished"
protect-secrets:
	npm run protect-secrets
	echo "secrets are safe"
expose-secrets:
	npm run expose-secrets
	echo "secrets ARE NOT SAFE"
run:
	echo "starting server..."
	hexo server
generate:
	hexo generate
deploy:
	echo "starting deployment..."
	hexo generate && ftpsync
	echo "deployment is done"

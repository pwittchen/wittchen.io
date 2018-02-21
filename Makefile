install:
	sudo npm install --unsafe-perm
theme:
	cd themes/custom && sudo npm install && gulp
protect-secrets:
	npm run protect-secrets
expose-secrets:
	npm run expose-secrets
run:
	hexo server
deploy:
	hexo generate && ftpsync

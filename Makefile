all: clean generate run
install: protect_secrets
	sudo npm install --unsafe-perm
	echo "installation finished"
theme:
	cd themes/custom && sudo npm install --unsafe-perm && gulp
protect_secrets:
	npm run protect-secrets
	echo "secrets are safe"
expose_secrets:
	npm run expose-secrets
	echo "secrets are NOT safe"
run:
	echo "starting server..."
	hexo server
server: run
generate:
	hexo generate
	echo "website is generated in public/ dir"
deploy: clean_public
	echo "starting deployment..."
	hexo generate && ./deploy.sh
discard:
	git checkout -- source
	git clean -f source
	echo "pages and posts discarded"
clean: clean_public
	rm db.json
	echo "clean is done"
clean_public:
	rm -rf public
clean_full: clean
	sudo rm -rf node_modules && rm -rf themes/custom/node_modules
	"full clean done, run make install rule to re-create environment"


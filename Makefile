all: clean generate update_docs run
install: protect_secrets
	sudo npm install --unsafe-perm
	echo "installation finished"
theme:
	cd themes/custom && sudo npm install && gulp
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
deploy:
	echo "starting deployment..."
	hexo generate && ftpsync
	echo "deployment FINISHED!"
discard:
	git checkout -- source
	git clean -f source
	echo "pages and posts discarded"
docs:
	mkdir docs
	docsify init docs
	echo "docs generated"
update_docs:
	cp README.md docs
	echo "docs updated"
clean_docs:
	rm -rf docs
	echo "docs/ dir is deleted"
run_docs:
	echo "starting docs server..."
	docsify serve docs
clean:
	rm -rf public
	rm db.json
	echo "clean is done"
clean_full: clean
	sudo rm -rf node_modules
	"full clean done, run make install rule to re-create environment"


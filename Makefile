install:
	sudo npm install --unsafe-perm
theme:
	cd themes/custom && sudo npm install --unsafe-perm && gulp
run:
	hexo server
rundrafts:
	hexo server --drafts
server: run
generate:
	hexo generate
regenerate: clean generate
discard:
	git checkout -- source
	git clean -f source
clean:
	rm -rf public
	rm db.json
cleanfull: clean
	sudo rm -rf node_modules && rm -rf themes/custom/node_modules


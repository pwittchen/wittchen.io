install:
	sudo npm install --unsafe-perm
theme:
	cd themes/custom && sudo npm install --unsafe-perm && gulp
run:
	hexo server
rundrafts:
	hexo server --drafts
generate:
	hexo generate
commit:
	git add -A && git commit -m "updating 'public' dir -> new website deployment"
push:
	git push
deploy: clean generate commit push
	@echo "started deployment"
discard:
	git checkout -- source
	git clean -f source
clean:
	rm -rf public
	rm db.json
prune: clean
	sudo rm -rf node_modules && rm -rf themes/custom/node_modules


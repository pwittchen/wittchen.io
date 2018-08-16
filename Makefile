all: clean generate update_docs run
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
deploy:
	echo "starting deployment..."
	hexo generate && ./deploy.sh
discard:
	git checkout -- source
	git clean -f source
	echo "pages and posts discarded"
docker_build: generate
	sudo docker build -t wittchenio .
docker_run:
	sudo docker run -p 127.0.0.1:4000:4000 -t wittchenio
docker_kill:
	./docker/kill_docker.sh
docker_delete:
	./docker/delete_docker.sh
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


all: clean generate run
install:
	sudo npm install --unsafe-perm
	echo "installation finished"
theme:
	cd themes/custom && sudo npm install --unsafe-perm && gulp
run:
	echo "starting server..."
	hexo server
server: run
generate:
	hexo generate
	echo "website is generated in public/ dir"
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


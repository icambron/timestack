build:
	@node_modules/coffee-script/bin/coffee -c -o files src/timestack.coffee
	@node_modules/uglify-js/bin/uglifyjs files/timestack.js > files/timestack.min.js
	@node_modules/less/bin/lessc src/timestack.less > files/timestack.css

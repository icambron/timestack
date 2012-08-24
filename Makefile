build:
	@coffee -c -o . src/timestack.coffee
	@node_modules/uglify-js/bin/uglifyjs timestack.js > timestack.min.js

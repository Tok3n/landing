require('newrelic');

var express = require("express"),
    blade = require('blade'),
    mime = require('mime'),
    app = express();

// Reference
// https://github.com/vincicat/heroku-express
// http://expressjs.com/guide.html
// https://github.com/spadin/simple-express-static-server
// http://devcenter.heroku.com/articles/node-js

mime.define({
  'application/vnd.ms-fontobject': 'eot',
  'application/x-font-woff': 'woff',
  'application/x-font-ttf': 'ttf',
  'image/svg+xml': 'svg'
});

// Configuration
app.configure(function(){
	app.use(express.static(__dirname + '/public'));
	app.use(express.bodyParser());
	app.use(express.methodOverride());

	app.set('views', __dirname + '/views');
	app.set('view engine', 'blade');
	app.locals.pretty = true;

	// Error Handling
	app.use(express.logger());
	app.use(express.errorHandler({
		dumpExceptions: true, 
		showStack: true
	}));

	//Setup the Route, you are almost done
	app.use(app.router);
});

app.get('/', function(req, res){
	res.render("index");
});

// Heroku
var port = process.env.PORT || 5000;
app.listen(port, function() {
	console.log("Listening on " + port);
});
var express = require('express'),
	  app = express.createServer()

// Reference
// https://github.com/vincicat/heroku-express
// http://expressjs.com/guide.html
// https://github.com/spadin/simple-express-static-server
// http://devcenter.heroku.com/articles/node-js

// Configuration
app.configure(function(){
	app.use(express.static(__dirname + '/public'));
	app.use(express.bodyParser());
	app.use(express.methodOverride());

	// app.set('views', __dirname + '/app/views');
	// app.register('.html', require('jade'));

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
	res.render("index.html");
});

// Heroku
var port = process.env.PORT || 3000;
app.listen(port, function() {
	console.log("Listening on " + port);
});
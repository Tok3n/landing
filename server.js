var connect = require('connect'),
    http = require('http');
    
connect.createServer(
		connect.static(__dirname)
).listen(80);

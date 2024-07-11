var http = require('http');

var finalhandler = require('finalhandler');
var serveStatic = require('serve-static');

var serve = serveStatic("../build");

var server = http.createServer(function(req, res) {
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin')
  res.setHeader('Cross-Origin-Embedder-Policy', 'require-corp')
  var done = finalhandler(req, res);
  serve(req, res, done);
});

server.listen(8000);
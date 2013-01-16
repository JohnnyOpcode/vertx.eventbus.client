load('vertx.js');

var server = vertx.createHttpServer()
	.setSSL(true)
	.setKeyStorePath('keystore.jks')
	.setKeyStorePassword('password');

var sockJSServer = vertx.createSockJSServer(server);
sockJSServer.bridge({prefix : '/eventbus'}, [{}], [{}] );

//server.listen(8080);
server.listen(4443);

// crossdomain.xml
vertx.createHttpServer()
	.requestHandler(function(req) {
		req.response.sendFile('crossdomain.xml');
	})
	.listen(843);
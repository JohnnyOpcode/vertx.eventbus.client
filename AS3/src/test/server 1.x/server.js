// Test server for Vert.x 1.3.1 release

load('vertx.js');

var server = vertx.createHttpServer()
	.setSSL(true)
	.setKeyStorePath('keystore.jks')
	.setKeyStorePassword('password');

var sockJSServer = vertx.createSockJSServer(server);
sockJSServer.bridge({prefix : '/eventbus'}, [{}], [{}] );

server.listen(443);

// serve the crossdomain.xml file to Flash player
// http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7c60.html
vertx.createHttpServer()
	.requestHandler(function(req) {
		req.response.sendFile('crossdomain.xml');
	})
	.listen(843);
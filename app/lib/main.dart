import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

// Listenning Port
const defaultPort = 5000;

// Global count to show on test page
int count = 0;

/// Init a server to respond to HTTP requests.
///
/// Configure handlers with log.
/// Stops the execution with a SIGINT Posix Signal.
void main() async {
  // Configure routes (favicon.ico without log)
  final app = Router(notFoundHandler: _handlerWithLog(_notFoundHandler));
  app.get('/', _handlerWithLog(_helloHandler));
  app.get('/favicon.ico', _notFoundHandler);

  // Start server
  final envPort = Platform.environment['PORT'];
  final port = envPort == null ? defaultPort : int.parse(envPort);
  final server = await shelf_io.serve(app, InternetAddress.anyIPv4, port);
  server.autoCompress = true;
  print('Serving at http://${server.address.host}:${server.port}');

  // Stop with grace on SIGINT
  final sigs = ProcessSignal.sigint.watch();
  sigs.listen((event) {
    server.close(force: true).then((_) => exit(0));
  });
}

/// Not Found Handler
Response _notFoundHandler(Request req) => Response.notFound('Route not found');

/// Hello Handler
///
/// Shows a message with an incremented counter
Response _helloHandler(Request req) {
  ++count;
  return Response.ok('Hello Kubernetes from DART $count from ${req.requestedUri}');
}

/// Wrap a handler on a log pipe
Handler _handlerWithLog(Handler handler) {
  return const Pipeline().addMiddleware(logRequests()).addHandler(handler);
}

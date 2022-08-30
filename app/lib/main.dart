import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// Default listenning port.
const defaultPort = 5000;

/// String with all non loopback IPv4 addresses.
late final String ipAddresses;

/// Global count to show on test page.
int count = 0;

/// Init a server to respond to HTTP requests.
///
/// Stops the execution with a SIGINT Posix Signal.
void main(List<String> argv) async {
  ipAddresses = await _ipAddresses();

  // Start server with configured routes
  final server = await _startServer(argv);

  // Stop with grace on SIGINT
  _listenToStopSignal(server);
}

/// Get all non loopback IPv4 internet addresses in this server.
///
/// Return a String joining all IPv4 addresses.
Future<String> _ipAddresses() async {
  final interfaces = await NetworkInterface.list();
  final addresses = [];
  for (final iface in interfaces) {
    for (final add in iface.addresses) {
      if (!add.isLoopback && add.type == InternetAddressType.IPv4) {
        addresses.add(add.address);
      }
    }
  }

  return addresses.length == 1 ? addresses.first : '[${addresses.join(' ')}]';
}

/// Start HttpServer.
///
/// Configure all routes.
/// Define server port using arguments, environment and default value.
/// Starts listenning on all interfaces (0.0.0.0)
/// Set autoCompress and prints server start
Future<HttpServer> _startServer(List<String> argv) async {
  final router = _configuredRouter();
  final port = _serverPort(argv);

  // Await for server start
  final server = await shelf_io.serve(router, InternetAddress.anyIPv4, port);

  server.autoCompress = true;
  print('Serving at http://${server.address.host}:${server.port}');

  return server;
}

/// Listen to Posix SIGINT Signal to stop the server and exit with status 0.
void _listenToStopSignal(HttpServer server) {
  final sigs = ProcessSignal.sigint.watch();
  sigs.listen((event) {
    server.close(force: true).then((_) => exit(0));
  });
}

/// Configure routes with logger.
///
/// Route to favicon.ico is set without log
Router _configuredRouter() {
  final router = Router(notFoundHandler: _handlerWithLog(_notFoundHandler));
  router.get('/', _handlerWithLog(_helloHandler));
  router.get('/favicon.ico', _notFoundHandler);
  return router;
}

/// Get server port.
///
/// Define server port using arguments, environment and default value.
int _serverPort(List<String> argv) {
  var portArg = Platform.environment['PORT'];
  for (final arg in argv) {
    if (arg.toLowerCase().startsWith('--port=')) {
      portArg = arg.substring(7);
      break;
    }
  }
  int? port;
  if (portArg != null) {
    port = int.tryParse(portArg);
  }
  return port ?? defaultPort;
}

/// Not Found Handler.
Response _notFoundHandler(Request req) => Response.notFound('Route not found');

/// Hello Handler.
///
/// Shows a message with an incremented counter
Response _helloHandler(Request req) {
  ++count;
  return Response.ok(
    'Hello $count from DART Kubernete! Serving ${req.requestedUri} from $ipAddresses',
  );
}

/// Wrap a handler on a log pipe.
Handler _handlerWithLog(Handler handler) {
  return const Pipeline().addMiddleware(logRequests()).addHandler(handler);
}

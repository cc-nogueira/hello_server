import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(_portArg(args) ?? Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  /// Listen to Posix SIGINT Signal to stop the server and exit with status 0.
  _listenToStopSignal(server);
}

/// Listen to Posix SIGINT Signal to stop the server and exit with status 0.
void _listenToStopSignal(HttpServer server) {
  final sigs = ProcessSignal.sigint.watch();
  sigs.listen((event) {
    server.close(force: true).then((_) => exit(0));
  });
}

// Search for --port=\d{2,4} argument
String? _portArg(List<String> args) {
  for (final arg in args) {
    if (arg.length > 8 && arg.length < 12 && arg.toLowerCase().startsWith('--port=')) {
      return arg.substring(7);
    }
  }
  return null;
}

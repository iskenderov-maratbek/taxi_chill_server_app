import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers.dart';

// Configure routes.
final _router = Router()
  ..get('/', rootHandler)
  ..get('/echo/<message>', echoHandler)
  ..post('/login', loginHandler);

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress('192.168.8.100');

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = 3000;
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers.dart';
import 'queries.dart';
import 'confirm_codes.dart';

void main(List<String> args) async {
  final ip = InternetAddress('192.168.8.100');
  final port = 3000;

  final conn = await Connection.open(
    Endpoint(
      host: '127.0.0.1',
      port: 5432,
      database: 'test_db',
      username: 'postgres',
      password: 'inaneonly1',
    ),
    settings: ConnectionSettings(
      sslMode: SslMode.disable,
    ),
  );
  ConfirmCodes codes = ConfirmCodes();
  DatabaseQueries dbQueries = DatabaseQueries(conn);
  Handlers handlers = Handlers(dbQueries, codes);

  final router = Router()
    ..get('/', handlers.rootHandler)
    ..get('/echo/<message>', handlers.echoHandler)
    ..post('/login-with-email', handlers.loginWithEmail)
    ..post('/login-with-number', handlers.loginWithNumber)
    ..post('/verify-code', handlers.verificationCode);

  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

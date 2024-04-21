import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final users = <String>[
  'user@example.com',
  'iskenderov.maratbek@gmail.com',
];

Response rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

loginHandler(Request request) async {
  print(' Login request received');
  sleep(Duration(seconds: 3));
  final params = await request
      .readAsString()
      .then((body) => jsonDecode(body) as Map<String, dynamic>);
  final email = params['email'] as String;
  if (users.contains(email)) {
    return Response.ok(jsonEncode({'token': 'some_token'}));
  } else {
    return Response.forbidden('Email not found');
  }
}

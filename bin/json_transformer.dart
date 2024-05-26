import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';

class JsonTransfomer {
  final Map<String, dynamic> request;
  JsonTransfomer(
    this.request,
  ) {}

  get number => request['number'];
}

Future<Map<String, dynamic>> decodeJson(Request request) =>
    request.readAsString().then((body) => jsonDecode(body) as Map<String, dynamic>);

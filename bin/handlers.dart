// handlers.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'confirm_codes.dart';
import 'queries.dart';

class Handlers {
  final DatabaseQueries dbQueries;
  final ConfirmCodes codes;
  Handlers(this.dbQueries, this.codes);

  Response rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  Future<Response> echoHandler(Request request) async {
    final message = request.params['message'];
    return Response.ok('Added $message to the database\n');
  }

  Future<Response> loginWithEmail(Request request) async {
    print('loginUser');
    final params = await request
        .readAsString()
        .then((body) => jsonDecode(body) as Map<String, dynamic>);
    final email = params['email'] as String;
    print('email: $email');
    if (email.isNotEmpty) {
      if (await dbQueries.checkUser(email)) {
        if (codes.hasCode(email)) {
          print('КОД ПОДТВЕРЖДЕНИЯ: ${codes.generateCode(email)}');
          //Отправляем код на почту
          return Response.ok('Код отправлен на почту');
        }
      }else{
        return Response.notFound('Аккаунт не зарегистрирован');
      }
    }
    return Response.badRequest(body: 'Ошибка, пожалуйста, попробуйте снова');
  }

  Future<Response> loginWithNumber(Request request) async {
    print('loginUser');
    final params = await request
        .readAsString()
        .then((body) => jsonDecode(body) as Map<String, dynamic>);
    final number = params['number'] as String;
    print('number: $number');
    if (number.isNotEmpty) {
      if (await dbQueries.checkUser(number)) {
        if (codes.hasCode(number)) {
          print('КОД ПОДТВЕРЖДЕНИЯ: ${codes.generateCode(number)}');
          //Отправляем код на почту
          return Response.ok('Код отправлен на почту');
        }
      }
    }
    return Response.badRequest(body: 'Ошибка, пожалуйста, попробуйте снова');
  }

  Future<Response> verificationCode(Request request) async {
    print('verificationCode');
    final params = await request
        .readAsString()
        .then((body) => jsonDecode(body) as Map<String, dynamic>);
    final verifyCode = params['verifyCode'] as String;
    final email = params['email'] as String;
    print('verifyCode: $verifyCode');
    print('email: $email');
    if (verifyCode.isNotEmpty) {
      var result = codes.checkCode(email: email, code: verifyCode);
      if (result != null) {
        return Response.notFound(result);
      } else {
        //Отправляем код на почту
        return Response.ok('Код подтвержден!');
      }
    }
    return Response.badRequest(body: 'Ошибка, пожалуйста, попробуйте снова');
  }

//   Future<Response> registerUser(Request request) async {
//     print('registerUser');
//     final params = await request
//         .readAsString()
//         .then((body) => jsonDecode(body) as Map<String, dynamic>);
//     final email = params['email'] as String;
//     final username = params['username'] as String;
//     print('email: $email');
//     if (email.isNotEmpty && username.isNotEmpty) {
//       if (await dbQueries.addUser(email, username) != null) {
//         codes.checkCode(email);
//         return Response.ok('Email is registered in Database!');
//       } else {
//         return Response.notFound('Email is not registered in Database!');
//       }
//     } else {
//       return Response.badRequest(body: 'Email empty');
//     }
//   }
}

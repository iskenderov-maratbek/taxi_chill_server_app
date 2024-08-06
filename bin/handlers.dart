// handlers.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'auth/message_service.dart';
import 'confirm_codes.dart';
import 'log.dart';
import 'queries.dart';

class Handlers {
  final DatabaseQueries dbQueries;

  final ConfirmCodes _codes;
  Handlers(this.dbQueries, this._codes);

  Future<String> jsontransform(dataname, Request request) async {
    var result =
        await request.readAsString().then((body) => jsonDecode(body) as Map<String, dynamic>);
    return result[dataname].toString();
  }

  // Response rootHandler(Request req) {
  //   return Response('Hello, World!\n');
  // }

  Future<Response> echoHandler(Request request) async {
    final message = request.params['message'];
    return Response.ok('Added $message to the database\n');
  }

  Future<Response> sendCodeEmail(Request request) async {
    await Future.delayed(Duration(seconds: 5));
    print('loginUser');
    // return Response.notFound('No registered');
    var email = await jsontransform('email', request);
    if (email != '' && await dbQueries.hasUser(email)) {
      var timeLeft = _codes.canSendCode(email);
      if (timeLeft == null) {
        var codeResult = await _codes.generateCode(email);
        sendAuthorizationCode(email, codeResult);
        print('КОД ПОДТВЕРЖДЕНИЯ: $codeResult');
      } else {
        return Response(422, body: 'Код уже был отправлен на номер: $email');
      }
      //Отправляем код на почту

      return Response.ok('Код был отправлен на номер: $email');
    } else {
      logInfo('Аккаунт не зарегистрирован');
      return Response.unauthorized('Аккаунт не зарегистрирован');
    }
  }

  Future<Response> loginWithNumber(Request request) async {
    print('loginUser');
    final number = await jsontransform('number', request);
    print('number: $number');
    if (number.isNotEmpty) {
      if (await dbQueries.hasUser(number)) {
        if (_codes.checkCode(number)) {
          print('КОД ПОДТВЕРЖДЕНИЯ: ${_codes.generateCode(number)}');
          //Отправляем код на почту
          return Response.ok('Код отправлен на почту');
        }
      }
    }
    return Response.badRequest(body: 'Ошибка, пожалуйста, попробуйте снова');
  }

  Future<Response> confirmCode(Request request) async {
    print('verificationCode');
    final params =
        await request.readAsString().then((body) => jsonDecode(body) as Map<String, dynamic>);
    logInfo('PARAMS: $params');
    final verifyCode = params['code'] as String;
    final email = params['email'] as String;
    print('code: $verifyCode');
    print('email: $email');
    if (verifyCode.isNotEmpty) {
      return _codes.checkCode(verifyCode)
          ? Response.notFound('notFound')
          : Response.ok('Код подтвержден!');
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

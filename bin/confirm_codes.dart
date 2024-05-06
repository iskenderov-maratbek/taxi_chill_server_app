import 'dart:math';

class ConfirmCodes {
  static final _random = Random();
  final Map<String, List> _codes = {};

  String generateCode(String email) {
    DateTime now = DateTime.now();

    _codes[email] = [List.generate(4, (_) => _random.nextInt(10)).join(), now];
    return _codes[email]?[0];
  }

  bool hasCode(String email) {
    if (_codes.containsKey(email)) {
      DateTime now = DateTime.now();
      return now.difference(_codes[email]?[1]).inSeconds >= 10;
    } else {
      return true;
    }
  }

  String? checkCode({required String code, required String email}) {
    if (_codes.containsKey(email)) {
      DateTime now = DateTime.now();
      if (now.difference(_codes[email]?[1]).inSeconds >= 60) {
        return 'Время действия кода истекло';
      } else {
        if (_codes[email]![0].toString().contains(code)) {
          return null;
        } else {
          return 'Неверный код!';
        }
      }
    } else {
      return 'Ошибка, попробуйте позже!';
    }
  }
}

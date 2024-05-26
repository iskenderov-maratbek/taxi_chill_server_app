 print('----- HMAC SHA-256 ------');
  hs256();
  print('-------------------------\n');
  print('----- RSA SHA-256 -----');
  rs256();
  print('-----------------------\n');
  print('----- ECDSA P-256 -----');
  es256();
  print('-----------------------\n');
  print('----- ECDSA secp256k -----');
  es256k();
  print('--------------------------\n');
  print('----- RSA-PSS SHA-256 -----');
  ps256();
  print('---------------------------\n');
  print('----- RSA Certificate -----');
  rsaCert();
  print('---------------------------\n');
}

void hs256() {
  String token;
 {
    final jwt = JWT(
      {
        'id': 123,
        'server': {
          'id': '3e4fc296',
          'loc': 'euw-2',
        }
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );
    token = jwt.sign(SecretKey('secret passphrase'));
    print('Signed token: $token\n');
  }
 {
    try {
      final jwt = JWT.verify(token, SecretKey('secret passphrase'));

      print('Payload: ${jwt.payload}');
    } on JWTExpiredException {
      print('jwt expired');
    } on JWTException catch (ex) {
      print(ex.message);
    }
  }
}

void rs256() {
  String token;
 {
    final jwt = JWT(
      {
        'id': 123,
        'server': {
          'id': '3e4fc296',
          'loc': 'euw-2',
        }
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );
    final pem = File('./example/rsa_private.pem').readAsStringSync();
    final key = RSAPrivateKey(pem);
    token = jwt.sign(key, algorithm: JWTAlgorithm.RS256);
    print('Signed token: $token\n');
  }
 {
    try {
      final pem = File('./example/rsa_public.pem').readAsStringSync();
      final key = RSAPublicKey(pem);

      final jwt = JWT.verify(token, key);

      print('Payload: ${jwt.payload}');
    } on JWTExpiredException {
      print('jwt expired');
    } on JWTException catch (ex) {
      print(ex.message); 
    }
  }
}
void es256() {
  String token;
   {
    final jwt = JWT(
      {
        'id': 123,
        'server': {
          'id': '3e4fc296',
          'loc': 'euw-2',
        }
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );
    final pem = File('./example/ec_private.pem').readAsStringSync();
    final key = ECPrivateKey(pem);
    token = jwt.sign(key, algorithm: JWTAlgorithm.ES256);
    print('Signed token: $token\n');
  }

 {
    try {
      final pem = File('./example/ec_public.pem').readAsStringSync();
      final key = ECPublicKey(pem);
      final jwt = JWT.verify(token, key);
      print('Payload: ${jwt.payload}');
    } on JWTExpiredException {
      print('jwt expired');
    } on JWTException catch (ex) {
      print(ex.message); 
    }
  }
}

void es256k() {
  String token;
 {
    final jwt = JWT(
      {
        'id': 123,
        'server': {
          'id': '3e4fc296',
          'loc': 'euw-2',
        }
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );
    final pem = File('./example/ec_256k_private.pem').readAsStringSync();
    final key = ECPrivateKey(pem);
    token = jwt.sign(key, algorithm: JWTAlgorithm.ES256K);
    print('Signed token: $token\n');
  }
 {
    try {
      final pem = File('./example/ec_256k_public.pem').readAsStringSync();
      final key = ECPublicKey(pem);
      final jwt = JWT.verify(token, key);
      print('Payload: ${jwt.payload}');
    } on JWTExpiredException
Расскажи мне про код подробно что он делает

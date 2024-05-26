// database_queries.dart

import 'package:postgres/postgres.dart';

class DatabaseQueries {
  final Connection connection;

  DatabaseQueries(this.connection);

  Future<bool> checkUser(String email) async {
    print('getUserByEmail: $email');
    final result = await connection.execute(
      Sql.named('''
     SELECT email
     FROM users
     WHERE email = @email
     '''),
      parameters: {'email': email},
    );
    return result.isNotEmpty ? email.contains(result.first.first.toString()) : false;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    print('getUserByEmail: $email');
    final result = await connection.execute(
      Sql.named('''
    SELECT id, email, username, profile_photo
     FROM users
     WHERE email = @email
     '''),
      parameters: {'email': email},
    );
    if (result.isNotEmpty) {
      // Отправляем код на почтовый адрес
      return result.first.toColumnMap();
    } else {
      return null;
    }
  }

  addUser(String email, String username) async {
    print('addUser: $email, $username');
    final result = await connection.execute(
      Sql.named('''
    INSERT INTO users (email, username)
    VALUES (@email, @username)
    '''),
      parameters: {'email': email, 'username': username},
    );
    print('result: $result');
    print('result: ${result.toList()}');
  }
}

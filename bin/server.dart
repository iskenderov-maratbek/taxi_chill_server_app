import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_framework/http.dart';
import 'package:angel3_graphql/angel3_graphql.dart';
import 'package:graphql_schema2/graphql_schema2.dart';
import 'package:graphql_server2/graphql_server2.dart';

void main() async {
  var app = Angel();
  var http = AngelHttp(app);

  final purchaseType = objectType(
    'Purchase',
    fields: [
      field('id', graphQLString),
      field('product', graphQLString),
      field('price', graphQLFloat),
      // Другие поля истории покупок, если нужно
    ],
  );

  // Пример GraphQL схемы
  var schema = graphQLSchema(
    queryType: objectType('Query', fields: [
      // Запрос для аутентификации
      field(
        'login',
        objectType('AuthPayload', fields: [
          field('accessToken', graphQLString),
          field('refreshToken', graphQLString),
          field('expiresIn', graphQLInt),
          field(
            'user',
            objectType('User', fields: [
              field('id', graphQLString),
              field('username', graphQLString),
              field('email', graphQLString),
              // Другие поля пользователя, если нужно
            ]),
          ),
        ]),
        resolve: (_, args) async {
          // Логика для аутентификации по номеру телефона и паролю
          // Возврат данных о пользователе и токенах доступа
        },
      ),

      // Запрос для получения истории покупок
      field(
        'purchaseHistory',
        listOf(purchaseType),
        resolve: (_, __) async {
          // Логика для получения истории покупок
        },
      ),
    ]),
  );

  // Создание GraphQL endpoint
  app.all('/graphql', graphQLHttp(GraphQL(schema)));

  // Обработка ошибок
  app.errorHandler = (e, req, res) {
    print('Error: $e');
    return res;
  };

  // Запуск сервера
  var server = await http.startServer('192.168.8.101', 3000);
  print('Server running on localhost:3000');
  print(server.address.host);
  print(server.address.isLinkLocal);
}

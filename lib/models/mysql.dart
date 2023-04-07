import 'package:mysql1/mysql1.dart';

// 192.168.137.1
// 192.168.153.1

class Mysql {
  static String host = '192.168.88.1', // ?? localhost ?? http://192.168.88.1/
                user = 'root',
                password = '130623',
                db = 'tasks';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    return await MySqlConnection.connect(settings);
  }
}
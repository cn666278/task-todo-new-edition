import 'dart:convert';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'package:todo_app_new_edition/models/mysql.dart';
import 'package:todo_app_new_edition/models/task.dart';

/* link to database using MySQL
* */
class DBHelper {
  static final Mysql _db = Mysql(); // database instance object
  static const String _tableName = "tasks";

  static final db = MysqlUtils(
    settings: {
      'host': '192.168.88.1',
      'port': 3306,
      'user': 'root',
      'password': '130623',
      'db': 'tasks',
      'maxConnections': 10,
      'secure': false,
      'prefix': '',
      'pool': false,
      'collation': 'utf8mb4_general_ci',
    },
    errorLog: (error) {
      print(error);
    },
    sqlLog: (sql) {
      print(sql);
    },
    connectInit: (db1) async {
      print('whenComplete');
    },
  );

  static Future<void> initDb() async {
    // TODO ??? HOW TO SOLVE THIS ??? CREATE TABLE ???
    // if (_db != null) {
    //   return;
    // }
    try {
      // Open a connection (Database:"tasks/tasks" should already exist)

      // Create a table
      print("CREATE TABLE");
      _db.getConnection().then((conn) {
        conn.query(
            "CREATE TABLE $_tableName (id int PRIMARY KEY AUTO_INCREMENT,"
                " title varchar(255), note varchar(255), date varchar(255),"
                " startTime varchar(50), remind int,"
                " `repeat` varchar(50), color int, isCompleted boolean, isStar boolean);"
        );
        // conn.close();
      });
    } catch (e) {
      print(e); // print the error
    }
  }


  static Future<int> insert(Task task) async {
    // Insert some data
    return await _db.getConnection().then((conn) {
      // TODO ??? IMPROVE THESE CODES
      conn.query(
        // 'INSERT INTO tasks (title, note) values (?, ?)', [task.title!, task.note!],
        'INSERT INTO $_tableName (title, note, isCompleted, date, startTime, color, remind, `repeat`, isStar) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          task.title!,
          task.note!,
          task.isCompleted!,
          task.date!,
          task.startTime!,
          // task.endTime!,
          task.color!,
          task.remind!,
          task.repeat!,
          task.isStar!,
        ],
      );
      return 0; //???
    });
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");

    return await _db.getConnection().then((conn) async {
      var row = await db
          .query('SELECT * FROM $_tableName');
      // print(row.toMap());

      // using the api [mysql_utils] to convert the type of row to List<dynamic>
      List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
          row.rows);
      return list;
    });
  }

  // TODO --- EDIT THE QUERY FUNCTION HERE FOR ...
  // static Future<List<Map<String, dynamic>>> queryTaskDetail(Task task) async {
  //   print("query task detail function called");
  //
  //   return await _db.getConnection().then((conn) async {
  //
  //     var row = await db
  //         // .query('SELECT * FROM $_tableName');
  //         .query('select name, email, age from users where id = ?', [result.insertId]);
  //     // print(row.toMap());
  //
  //     // using the api [mysql_utils] to convert the type of row to List<dynamic>
  //     List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(row.rows);
  //     return list;
  //   });
  // }

  static Future<List<Map<String, dynamic>>> queryTaskDetail(Task task) async {
    print("query task detail function called");

    return await _db.getConnection().then((conn) async {
      var row = await db.getOne(
        table: 'tasks',
        fields: '*',
        where: {'id': task.id}, // toString()??
      );
      print(row);

      // using the api [mysql_utils] to convert the type of row to List<dynamic>
      List<Map<String, dynamic>> detail = List<Map<String, dynamic>>.from(row.values);
      return detail;
    });
  }

  static delete(Task task) async {
    // return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
    return await _db.getConnection().then((conn) {
      conn.query('DELETE FROM $_tableName WHERE id = ?', [task.id!]);
    });
  }

  static update(int id) async {
    return await _db.getConnection().then((conn) {
      conn.query('''
            UPDATE $_tableName
            SET isCompleted = ?
            WHERE id = ?
          ''', [true, id]);
    });
  }

  static markStar(int id) async {
    return await _db.getConnection().then((conn) {
      conn.query('''
            UPDATE $_tableName
            SET isStar = ?
            WHERE id = ?
          ''', [true, id]);
    });
  }
}

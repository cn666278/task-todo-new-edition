import 'dart:convert';

import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_new_edition/models/mysql.dart';
import 'package:todo_app_new_edition/models/task.dart';

/* link to database using sqflite
* */
class DBHelper {
  // static Database? _db; // database instance object
  static Mysql _db = new Mysql();
  static final int _version = 1;
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
    if (_db != null) {
      return;
    }
    try {
      // Open a connection (Database:"tasks" should already exist)

      // Create a table
      print("CREATE TABLE");
      _db.getConnection().then((conn) {
        conn.query(
            "CREATE TABLE $_tableName (id int PRIMARY KEY AUTOINCREMENT, title varchar(255),"
                " note varchar(255), date varchar(255),"
                " startTime varchar(50),endTime varchar(50),"
                " remind int, `repeat` varchar(50),"
                "color int, isCompleted int);"

          // "CREATE TABLE $_tableName ("
          // "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          // "title STRING, note TEXT, date STRING, "
          // "startTime STRING, endTime STRING, "
          // "remind INTEGER, repeat STRING, "
          // "color INTEGER, "
          // "isCompleted INTEGER)",
        );
        conn.close();
      });

      // DATABASE name: tasks.db
      // Create a database
      // String _path = await getDatabasesPath() + 'tasks.db';
      // _db = await openDatabase(
      //     _path,
      //     version: _version,
      //     onCreate: (db, version){
      //       print("create a new one");
      //       return db.execute(
      //         "CREATE TABLE $_tableName("
      //             "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      //             "title STRING, note TEXT, date STRING, "
      //             "startTime STRING, endTime STRING, "
      //             "remind INTEGER, repeat STRING, "
      //             "color INTEGER, "
      //             "isCompleted INTEGER)",
      //       );
      //   },
      // );
    } catch (e) {
      print(e); // print the error
    }
  }

  static Future<int> insert(Task task) async {
    ////insert
    // var res3 = await db.insert(
    //   table: 'tasks',
    //   insertData: {
    //     'telphone': '+113888888888',
    //     'createTime': 1620577162252,
    //     'updateTime': 1620577162252,
    //   },
    // );
    // await db.close();
    // print("TEST DB");
    // print(res3); //lastInsertID

    // Insert some data
    // return await _db?.insert(_tableName, task!.toJson()) ?? 1; // ? !: null check
    return await _db.getConnection().then((conn) {
      // TODO ??? IMPROVE THESE CODES
      conn.query(
        // 'INSERT INTO tasks (title, note) values (?, ?)', [task.title!, task.note!],
        'INSERT INTO $_tableName (title, note, isCompleted, date, startTime, endTime, color, remind, `repeat`) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          task.title!,
          task.note!,
          task.isCompleted!,
          task.date!,
          task.startTime!,
          task.endTime!,
          task.color!,
          task.remind!,
          task.repeat!,
        ],
        // 'INSERT INTO tasks (title, note, isCompleted, date, startTime, endTime, color, remind, repeat) values (?, ?, ?, ?, ?, ?, ?, ?, ?)', [
        //   task.title!,
        //   task.note!,
        //   task.isCompleted!,
        //   task.date!,
        //   task.startTime!,
        //   task.endTime!,
        //   task.color!,
        //   task.remind!,
        //   task.repeat!
        // ],
        // [task.title!, task.note!, task.isCompleted!, task.date!],
      );
      return 0; //???
    });
  }

  // static Future<Results> query() async {
  //   print("query function called");
  //   // Query the database using a parameterized query
  //
  //   // return await _db!.query(_tableName);
  //   return await _db.getConnection().then((conn) {
  //     Future<Results> results = conn
  //         .query('SELECT * FROM $_tableName');
  //     print(results);
  //     // Future<List<Map<String, dynamic>>> results = conn
  //     //     .query('SELECT * FROM $_tableName') as Future<List<Map<String, dynamic>>>;
  //     // taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  //     return results; //???
  //   });
  // }

  static Future<List<Map<String, dynamic>>> query() async {
    // var taskList = <Task>[].obs;
    var row = await db
        .query('SELECT * FROM $_tableName');
    // print(row.toMap());

    // var results = row.toMap();
    // using the api [mysql_utils] to convert the type of row to List<dynamic>
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(row.rows);
    return list;
  }


  static delete(Task task) async {
    // return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
    return await _db.getConnection().then((conn) {
      conn.query('DELETE FROM $_tableName WHERE id = ?', [task.id!]);
    });
  }

  static update(int id) async {
    // sql
    return await _db.getConnection().then((conn) {
      conn.query('''
            UPDATE $_tableName
            SET isCompleted = ?
            WHERE id = ?
          ''', [1, id]);
    });

    // return await _db!.rawUpdate('''
    //   UPDATE tasks
    //   SET isCompleted = ?
    //   WHERE id = ?
    // ''', [1,id]);
  }
}

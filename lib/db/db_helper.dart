import 'package:sqflite/sqflite.dart';
import 'package:todo_app_new_edition/models/task.dart';

class DBHelper {
  static Database? _db; // database instance object
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: 1,
        onCreate: (db, version) {
          print("CREATE TABLE");
          // there is no boolean type in SQLite
          return db.execute(
              "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  " title TEXT, note TEXT, date TEXT,"
                  " startTime TEXT, remind INTEGER,"
                  " `repeat` TEXT, color INTEGER,"
                  " isCompleted INTEGER, isStar INTEGER);");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static Future<List<Map<String, dynamic>>> queryTaskDetail(Task task) async {
    print("query task detail function called");
    return await _db!.query(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> updateTaskDetail(Task task) async {
    print("update task detail function called");
    return await _db!.update(_tableName, task.toJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> delete(Task task) async {
    print("delete function called");
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> update(int id) async {
    print("update function called");
    return await _db!.update(
      _tableName,
      {'isCompleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> undoCompleted(int id) async {
    print("undoCompleted function called");
    return await _db!.update(
      _tableName,
      {'isCompleted': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> markStar(int id) async {
    print("markStar function called");
    return await _db!.update(
      _tableName,
      {'isStar': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> undoStar(int id) async {
    print("undoStar function called");
    return await _db!.update(
      _tableName,
      {'isStar': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

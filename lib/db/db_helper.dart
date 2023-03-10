import 'package:sqflite/sqflite.dart';
import 'package:todo_app_new_edition/models/task.dart';

/* link to database using sqflite
* */
class DBHelper{
  static Database? _db; // database instance object
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async{
    if(_db != null){
      return;
    }
    try{
      // DATABASE name: tasks.db
      // Create a database
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
          _path,
          version: _version,
          onCreate: (db, version){
            print("create a new one");
            return db.execute(
              "CREATE TABLE $_tableName("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "title STRING, note TEXT, date STRING, "
                  "startTime STRING, endTime STRING, "
                  "remind INTEGER, repeat STRING, "
                  "color INTEGER, "
                  "isCompleted INTEGER)",
            );
        },
      );
    } catch(e){
      print(e); // print the error
    }
  }

  static Future<int> insert(Task? task) async{
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1; // ? !: null check
  }

  static Future<List<Map<String, dynamic>>> query() async{
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async{
    // sql
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1,id]);
  }
}
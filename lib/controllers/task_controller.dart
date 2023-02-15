import 'package:get/get.dart';
import 'package:todo_app_new_edition/db/db_helper.dart';
import 'package:todo_app_new_edition/models/task.dart';

// import '../models/task.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;

  // await 异步处理
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  // get all the data from table
  void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  // void delete(Task task){
  //   DBHelper.delete(task);
  //   getTasks(); // update the current new task list
  //   // after delete we have to update the task page
  // }
  //
  // // using await otherwise you might not get any result,
  // // because update will take some time then you wait until it return result then you return
  // void markTaskCompleted(int id) async{
  //   await DBHelper.update(id);
  //   getTasks(); // update the current new task list
  // }
}
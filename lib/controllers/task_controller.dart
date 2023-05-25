import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:todo_app_new_edition/db/db_helper.dart';
import 'package:todo_app_new_edition/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;
  var taskDetailList = <Task>[].obs;

  // await 异步处理
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  void updateTask({Task? task}) async {
    print("update task detail");
    await DBHelper.updateTaskDetail(task!);
    getTasks(); // ?
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    // print(tasks);
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    // print(taskList);
  }

  void delete(Task task) async {
    await DBHelper.delete(task);
    getTasks(); // update the current new task list
    // after delete we have to update the task page
  }

  // using await otherwise you might not get any result,
  // because update will take some time then you wait until it return result then you return
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks(); // update the current new task list
  }

  void undoTaskCompleted(int id) async {
    await DBHelper.undoCompleted(id);
    getTasks(); // update the current new task list
  }

  void markTaskStar(int id) async {
    await DBHelper.markStar(id);
    getTasks(); // update the current new task list
  }

  void undoTaskStar(int id) async {
    await DBHelper.undoStar(id);
    getTasks(); // update the current new task list
  }

  // get all the data from table
  void getTaskDetails(Task task) async {
    // todo edit the function query()
    List<Map<String, dynamic>> taskDetail =
        await DBHelper.queryTaskDetail(task);
    taskDetailList
        .assignAll(taskDetail.map((data) => Task.fromJson(data)).toList());
    // print(taskDetailList);
  }

  // get total tasks
  Future<double> getTotalTask() async {
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      res += 1;
    }
    return res;
  }


  // TODO -- get total completed tasks
  Future<double> getTotalCompletedTask() async {
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].isCompleted == true) {
        res += 1;
      }
    }
    return res;
  }

  Future<int> getTotalCompletedProgress() async {
    int totalProgress = 0;
    double comp = await getTotalCompletedTask();
    double total = await getTotalTask();
    // use toInt() but not as int
    // totalProgress = ((comp / total) * 100) as int; // wrong
    totalProgress = ((comp / total) * 100).toInt();
    return totalProgress;
  }

}

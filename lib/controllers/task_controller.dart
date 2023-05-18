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
    // todo edit the dunction query()
    List<Map<String, dynamic>> taskDetail =
        await DBHelper.queryTaskDetail(task);
    taskDetailList
        .assignAll(taskDetail.map((data) => Task.fromJson(data)).toList());
    // print(taskDetailList);
  }

  int getTotalTask(Task task) {
    var res = 0;
    // TODO -- get total tasks
    // for(int i = 0; i < task.length; i++){
    //   if(task[i].todos != null){
    //     res += task[i].id.length;
    //   }
    // }
    return res;
  }

  int getTotalCompletedTask(Task task) {
    var res = 0;
    // TODO -- get total completed tasks
    // for(int i = 0; i < task.length; i++){
    //   if(task[i].todos != null){
    //     for(int j = 0; j < task[i].todos!.length; j++){
    //       if(task[i].todos![j]['isCompleted'] == true){
    //         res += 1;
    //       }
    //     }
    //   }
    // }
    return res;
  }
}

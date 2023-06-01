import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    getTasks();
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
    res = taskList.length.toDouble();
    return res;
  }

  // get total tasks today
  Future<double> getOneDayTask() async {
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    double res = taskList
        .where((task) => task.date == DateFormat.yMd().format(today))
        .length
        .toDouble();

    // using .where() to simplify the codes below:
    // double res = 0;
    // List<Map<String, dynamic>> tasks = await DBHelper.query();
    // taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    // for (int i = 0; i < taskList.length; i++) {
    //   if (taskList[i].date == DateFormat.yMd().format(today)) {
    //     res += 1;
    //   }
    // }
    return res;
  }

  // get total tasks under 7 days (started from today)
  Future<double> getSevenDaysTasks() async {
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    double res = taskList
        .where((task) =>
            isWithinSevenDays(DateFormat.yMd().parse(task.date!), today))
        .length
        .toDouble();
    return res;
  }

  // get total tasks under same month (same as today)
  Future<double> getThisMonthTasks() async {
    DateTime today = DateTime.now();
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());

    for (int i = 0; i < taskList.length; i++) {
      DateTime taskDate = DateFormat.yMd().parse(taskList[i].date!);
      if (isWithinSameMonth(taskDate, today)) {
        res += 1;
      }
    }

    return res;
  }

  // get total completed tasks
  Future<double> getTotalCompletedTask() async {
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].isCompleted == 1) {
        res += 1;
      }
    }
    return res;
  }

  // get total completed tasks today
  Future<double> getOneDayCompletedTask() async {
    DateTime today = DateTime.now();
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].date == DateFormat.yMd().format(today) &&
          taskList[i].isCompleted == 1) {
        res += 1;
      }
    }
    return res;
  }

  // get total completed tasks under 7 days (started from today)
  Future<double> getSevenDaysCompletedTasks() async {
    DateTime today = DateTime.now();
    double res = taskList
        .where((task) =>
            task.isCompleted == 1 &&
            isWithinSevenDays(DateFormat.yMd().parse(task.date!), today))
        .length
        .toDouble();

    return res;
  }

  // get total completed tasks under same month (same as today)
  Future<double> getMonthCompletedTasks() async {
    DateTime today = DateTime.now();
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());

    for (int i = 0; i < taskList.length; i++) {
      DateTime taskDate = DateFormat.yMd().parse(taskList[i].date!);
      if (taskList[i].isCompleted == 1 && isWithinSameMonth(taskDate, today)) {
        res += 1;
      }
    }

    return res;
  }

  // judge logic
  bool isWithinSameMonth(DateTime taskDate, DateTime today) {
    return taskDate.month == today.month && taskDate.year == today.year;
  }

  bool isWithinSevenDays(DateTime taskDate, DateTime today) {
    Duration difference = today.difference(taskDate);
    return difference.inDays <= 6;
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

  Future<double> getTotalStarTask() async {
    double res = 0;
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].isStar == 1) {
        res += 1;
      }
    }
    return res;
  }

  Future<int> getTotalStarProgress() async {
    int totalProgress = 0;
    double star = await getTotalStarTask();
    double total = await getTotalTask();
    // use toInt() but not as int
    // totalProgress = ((comp / total) * 100) as int; // wrong
    totalProgress = ((star / total) * 100).toInt();
    return totalProgress;
  }
}

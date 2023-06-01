import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_new_edition/controllers/task_controller.dart';
import 'package:todo_app_new_edition/models/task.dart';
import 'package:todo_app_new_edition/ui/widgets/input_field.dart';
import 'package:todo_app_new_edition/ui/widgets/update_button.dart';
import 'package:todo_app_new_edition/utils/theme.dart';

// Details page
// convert StatelessWidget to StatefulWidget by Alt + ENTER
class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailPage> {
  late Task? task = widget.task; // todo how to get the task?
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5; // initial value
  List<int> reminderList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    _selectedColor = task!.color!;
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.task, color: _getBGClr(task?.color ?? 0)),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        task!.title!,
                        style: headingStyle,
                      ),
                    ],
                  ),
                  // _colorPalette(),
                ],
              ),
              MyInputField(
                title: "Title",
                hint: task!.title!,
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: task!.note!,
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: task!.date!,
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print("Your click the Date choose function");
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Start Time",
                    hint: task!.startTime!,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        )),
                  )),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "${task!.remind!} minutes early",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  // estimate the underline
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind =
                          int.parse(newValue!); // saved the selected time
                      task?.remind = _selectedRemind;
                    });
                  },
                  items:
                      reminderList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: task!.repeat!,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  // estimate the underline
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!; // saved the selected value
                      task?.repeat = _selectedRepeat;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  Container(),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: UpdateButton(
                        label: " Update", onTap: () => _validateDate()),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /* 控制TASK LIST 卡片颜色 */
  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      case 3:
        return deepOrange;
      default:
        return bluishClr;
    }
  }

  _validateDate() {
    _updateTaskToDb();
    _taskController.getTasks();
    Get.back();
  }

  /* Update task to database */
  _updateTaskToDb() {
    _taskController.updateTask(
        task: Task(
      id: task?.id,
      title:
          _titleController.text.isEmpty ? task?.title : _titleController.text,
      note: _noteController.text.isEmpty ? task?.note : _noteController.text,
      date: task?.date,
      startTime: task?.startTime,
      remind: task?.remind,
      repeat: task?.repeat,
      color: task?.color,
      isCompleted: task?.isCompleted,
      isStar: task?.isStar,
    ));
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Color",
        //   style: titleStyle,
        // ),
        // SizedBox(
        //   height: 8.0,
        // ),
        // Wrap widget can help put things in horizontal line
        Wrap(
          // used for the horizontal layout
          children: List<Widget>.generate(4, (int index) {
            return GestureDetector(
              // make the color selectable
              onTap: () {
                setState(() {
                  // use setState() to trigger the result
                  _selectedColor = index; // save the index color
                  task?.color = _selectedColor;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      // add more colors here
                      index == 0
                          ? primaryClr
                          : index == 1
                              ? pinkClr
                              : index == 2
                                  ? yellowClr
                                  : Colors.deepOrange,
                  // we want to show the selected color with tick only,
                  // other should be blank (empty Container)
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      // eliminate the shadow of header banner
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back(); // back to previous page
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          // Icon color should change according to the Theme Mode
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: const Text(
        "Task Details",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        task?.date = DateFormat.yMd().format(_pickerDate);
        // print(_selectedDate);
      });
    } else {
      print("it is null or something went wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimepicker();
    String formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
        task?.startTime = _startTime;
      });
    }
  }

  _showTimepicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}

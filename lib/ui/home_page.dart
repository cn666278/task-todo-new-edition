import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_new_edition/controllers/task_controller.dart';
import 'package:todo_app_new_edition/models/task.dart';
import 'package:todo_app_new_edition/services/notification_services.dart';
import 'package:todo_app_new_edition/services/theme_services.dart';
import 'package:todo_app_new_edition/ui/theme.dart';
import 'package:todo_app_new_edition/ui/widgets/button.dart';
import 'package:todo_app_new_edition/ui/add_task_bar.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// update from 2023/02/09
class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification(); // initialize
    notifyHelper.requestIOSPermissions();
    setState(() {
      print("I am here");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      // using for the two columns on the top to show Time, date and add task bar
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);

              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]),
                          )
                        ],
                      ),
                    ),
                  ));
            });
      }),
    );
  }

  /* used to show the task state: Task Completed / Delete Task
  * */
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      // judge the BottomSheet height by the variable: isCompleted 0/1
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context,
                ),
          _bottomSheetButton(
            label: "Delete Task",
            onTap: () {
              Get.back();
            },
            clr: Colors.red[400]!,
            context: context,
          ),
          SizedBox(height: 22,),
          _bottomSheetButton(
            label: "Close",
            onTap: () {
              Get.back();
            },
            clr: Colors.white,
            isClose: true, // set as ture
            context: context,
          ),
          SizedBox(height: 10,),
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
          width: 2,
          color: isClose == true ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[350]! : clr,
        ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            // TODO copyWith() -- COPY ALL THE PROPERTY OF THE INSTANCE AND CHANGE SOME
            style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // rebuilt the Container() in _addDateBar
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 95,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400]),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  // rebuilt the Container() in _appTaskBar
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // wrap Column with a container so that can add padding, margin..
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // margin left
              children: [
                // you can change the time showing format by DateFormat.yMMMd()
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                // TODO !!! IMPORTANT FOR HOMEPAGE DISPLAY
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              }) // Get.to: jump to a new page
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0, // eliminate the shadow of header banner
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme changed",
            body: Get.isDarkMode
                ? "Activated Light Theme"
                : "Activated Dark Theme",
          );
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          // Day and moon icon should change according to the Theme Mode
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_rounded,
          size: 20,
          // Icon color should change according to the Theme Mode
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          // Icon color should change according to the Theme Mode
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        // 头像png控件
        // CircleAvatar(
        //   backgroundImage: AssetImage(
        //     "images/header.png"
        //   ),
        // ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_new_edition/controllers/task_controller.dart';
import 'package:todo_app_new_edition/models/mysql.dart';
import 'package:todo_app_new_edition/models/task.dart';
import 'package:todo_app_new_edition/services/notification_services.dart';
import 'package:todo_app_new_edition/services/theme_services.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/all_task.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/calendar.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/entry_point.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/highlight.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/report.dart';
import 'package:todo_app_new_edition/ui/widgets/btm_nav/navigation.dart';
import 'package:todo_app_new_edition/ui/widgets/button.dart';
import 'package:todo_app_new_edition/ui/add_task_bar.dart';
import 'package:todo_app_new_edition/ui/details.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile/all_task_tile.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile/grey_task_tile.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile/task_tile.dart';
import 'package:todo_app_new_edition/utils/constants.dart';
import 'package:todo_app_new_edition/utils/icons.dart';
import 'package:todo_app_new_edition/utils/theme.dart';

class HighlightPage extends StatefulWidget {
  const HighlightPage({Key? key}) : super(key: key);

  @override
  State<HighlightPage> createState() => _HighlightPageState();
}

class _HighlightPageState extends State<HighlightPage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  int currentIndex = 0;

  // by default first item will be selected
  int selectedIndex = 0;
  List categories = ['To do', 'Completed', 'All'];

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
      Get.to(pages[index]);
    });
  }

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification(); // initialize
    notifyHelper.requestIOSPermissions();
    setState(() {
      _taskController.getTasks();
      print("Initialize");
    });
  }

  List pages = [
    AllTask(),
    Calendar(),
    Highlight(),
    Report(),
  ];

  @override
  Widget build(BuildContext context) {
    print("Highlight Page");
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      // using for the two columns on the top to show Time, date and add task bar
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop),
              image: Image.asset("assets/Backgrounds/colorful_bg.png").image,
            )),
        child: Column(
          children: [
            _addTaskBar(),
            // _addDateBar(),
            const SizedBox(
              height: 10,
            ),
            // CategoryList(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          left: kDefaultPadding,
                          // At end item it add extra 20 right  padding
                          right:
                          index == categories.length - 1 ? kDefaultPadding : 0,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        decoration: BoxDecoration(
                          color: index == selectedIndex
                              ? primaryClr.withOpacity(0.95)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          categories[index],
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color:
                            index == selectedIndex ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Category logic
            selectedIndex == 0
                ? _showTodoStarTasks()
                : selectedIndex == 1
                ? _showCompletedStarTasks()
                : selectedIndex == 2
                ? _showAllStarTasks()
                : null,
          ],
        ),
      ),
      bottomNavigationBar: BuildNavigation(
        currentIndex: currentIndex,
        onTap: onIndexChanged, // tab switch event
        items: [
          NavigationItemModel(
            label: "All Task",
            icon: SvgIcon.layout,
          ),
          NavigationItemModel(
            label: "Calendar",
            icon: SvgIcon.calendar,
          ),
          NavigationItemModel(
            label: "Highlight",
            icon: SvgIcon.tag,
          ),
          NavigationItemModel(
            label: "Report",
            icon: SvgIcon.clipboard,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: menuIconColor,
        onPressed: () async {
          await Get.to(() => const AddTaskPage());
          _taskController.getTasks();
        },
        child: const Icon(Icons.add_circle_rounded, size: 50),
      ),
      // float button
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked, //控制浮动按钮停靠在底部中间位置
    );
  }

  _showAllStarTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isStar == true) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: AllTaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container(); // cannot find any match date
              }
            });
      }),
    );
  }

  _showTodoStarTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isCompleted == false && task.isStar == true) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container(); // cannot find any match date
              }
            });
      }),
    );
  }

  _showCompletedStarTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isCompleted == true && task.isStar == true) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: GreyTaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container(); // cannot find any match date
              }
            });
      }),
    );
  }

  /* used to show the task state: Task Completed / Delete Task
  * */
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      // judge the BottomSheet height by the variable: isCompleted 0/1
      height: MediaQuery.of(context).size.height * 0.32,
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
          const Spacer(),
          task.isCompleted == true
              ? _bottomSheetButton(
            label: "Undo Completed",
            onTap: () {
              _taskController.undoTaskCompleted(task.id!); // UPDATE
              Get.back();
            },
            clr: Colors.green,
            context: context,
          )
              : _bottomSheetButton(
            label: "Task Completed",
            // TODO -- Add warning message to avoid wrong selection
            onTap: () {
              _taskController.markTaskCompleted(task.id!); // UPDATE
              Get.back();
            },
            clr: primaryClr,
            context: context,
          ),
          _bottomSheetButton(
            label: "Delete Task",
            onTap: () {
              // TODO -- Add warning message to avoid wrong deletion
              _taskController.delete(task); // DELETE
              Get.back();
            },
            clr: Colors.red[400]!,
            context: context,
          ),
          const SizedBox(
            height: 22,
          ),
          _bottomSheetButton(
            label: "Details",
            onTap: () async {
              await Get.to(() => TaskDetailPage(task: task));
              _taskController.getTasks();
            },
            clr: Colors.white,
            isClose: true,
            // set as ture
            context: context,
          ),
          const SizedBox(
            height: 10,
          ),
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
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[350]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            // copyWith() -- COPY ALL THE PROPERTY OF THE INSTANCE AND CHANGE SOME
            style:
            isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
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
                  DateFormat.EEEE().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Star Task",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            // Star Task progress design display
              label: "StarProgress",
              onTap: () async {
                // await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      // eliminate the shadow of header banner
      backgroundColor: context.theme.backgroundColor,
      actions: [
        IconButton(
            onPressed: () {
              // Logic for theme change
              ThemeServices().switchTheme();
              notifyHelper.displayNotification(
                title: "Theme changed",
                body: Get.isDarkMode
                    ? "Activated Light Theme"
                    : "Activated Dark Theme",
              );
              notifyHelper.scheduledNotification();
            },
            icon: Icon(
              // Day and moon icon should change according to the Theme Mode
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_rounded,
              size: 20,
              // Icon color should change according to the Theme Mode
              color: Get.isDarkMode ? Colors.white : Colors.black,
            )),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}

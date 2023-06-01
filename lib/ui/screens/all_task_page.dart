import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:todo_app_new_edition/controllers/task_controller.dart';
import 'package:todo_app_new_edition/db/db_helper.dart';
import 'package:todo_app_new_edition/models/mysql.dart';
import 'package:todo_app_new_edition/models/task.dart';
import 'package:todo_app_new_edition/services/notification_services.dart';
import 'package:todo_app_new_edition/services/theme_services.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/all_task.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/calendar.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/highlight.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/report.dart';
import 'package:todo_app_new_edition/ui/widgets/btm_nav/navigation.dart';
import 'package:todo_app_new_edition/ui/add_task_bar.dart';
import 'package:todo_app_new_edition/ui/details.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile/all_task_tile.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile/grey_task_tile.dart';
import 'package:todo_app_new_edition/ui/widgets/task_tile/task_tile.dart';
import 'package:todo_app_new_edition/utils/constants.dart';
import 'package:todo_app_new_edition/utils/icons.dart';
import 'package:todo_app_new_edition/utils/theme.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({Key? key}) : super(key: key);

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  int currentIndex = 0;

  // by default first item will be selected
  int selectedIndex = 0;
  List categories = ['To do', 'Completed', 'All'];

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
      // [GETX] WARNING, consider using: "Get.to(() => Page())" instead of "Get.to(Page())".
      // Using a widget function instead of a widget fully
      // guarantees that the widget and its controllers
      // will be removed from memory when they are no longer used.
      Get.to(pages[index]);
    });
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
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
    print("All Task Page");
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
          image: Get.isDarkMode
              ? Image.asset("assets/Backgrounds/colorful_dark_bg.png").image
              : Image.asset("assets/Backgrounds/colorful_bg.png").image,
        )),
        child: Column(
          children: [
            _addTaskBar(),
            // Container(
            //   width: double.infinity,
            //   height: 15,
            //   padding: EdgeInsets.symmetric(horizontal: 24.0),
            //   child: LiquidLinearProgressIndicator(
            //     backgroundColor: Colors.white,
            //     valueColor: AlwaysStoppedAnimation(Colors.pink),
            //     borderColor: Colors.red,
            //     borderWidth: 5.0,
            //     direction: Axis.horizontal,
            //   ),
            // ),
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
                itemBuilder: (context, index) => GestureDetector(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                ? _showTodoTasks()
                : selectedIndex == 1
                    ? _showCompletedTasks()
                    : selectedIndex == 2
                        ? _showTasks()
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
            // count: 3,
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

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task != null) {
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

  _showTodoTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isCompleted == 0) {
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

  _showCompletedTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isCompleted == 1) {
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
      padding: EdgeInsets.only(top: 4),
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
          Spacer(),
          task.isCompleted == 1
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
          SizedBox(
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
          SizedBox(
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
        margin: EdgeInsets.symmetric(vertical: 4.0),
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
                // todo ? StepProgressIndicator
                // StepProgressIndicator(
                //   totalSteps: 100,
                //   currentStep: 90,
                //   // currentStep: homeCtrl.isTodoEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
                //   size: 5,
                //   padding: 0,
                //   selectedGradientColor: LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: [Colors.blueAccent.withOpacity(0.5),Colors.blueAccent],
                //   ),
                //   unselectedGradientColor: const LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: [Colors.white, Colors.white],
                //   ),
                // ),
                // you can change the time showing format by DateFormat.yMMMd()
                Text(
                  DateFormat.MMMEd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "All Task",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: LiquidCircularProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(bluishClr.withOpacity(0.5)),
              // valueColor: AlwaysStoppedAnimation(Colors.blueAccent[400]!),
              borderColor: bluishClr,
              borderWidth: 5.0,
              // getTotalTask is type of Future<int> so we have to use FutureBuilder
              center: FutureBuilder<int>(
                future: _taskController.getTotalCompletedProgress(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  int result = snapshot.data ?? 0;
                  return Text(
                    result.toString() + "%",
                    style: const TextStyle(
                      color: bluishClr,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          // MyButton(
          //     // TODO Task progress design display
          //     label: " Progress",
          //     onTap: () async {
          //       await Get.to(() => AddTaskPage());
          //       _taskController.getTasks();
          //     })
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

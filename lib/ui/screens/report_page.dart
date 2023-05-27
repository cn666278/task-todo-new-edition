import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app_new_edition/controllers/task_controller.dart';
import 'package:todo_app_new_edition/services/notification_services.dart';
import 'package:todo_app_new_edition/services/theme_services.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/all_task.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/calendar.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/highlight.dart';
import 'package:todo_app_new_edition/ui/widgets/btm_nav/navigation.dart';
import 'package:todo_app_new_edition/ui/add_task_bar.dart';
import 'package:todo_app_new_edition/utils/constants.dart';
import 'package:todo_app_new_edition/utils/icons.dart';
import 'package:todo_app_new_edition/utils/theme.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  int currentIndex = 0;
  int totalTask = 0;
  int completedTask = 0;

  // by default first item will be selected
  int selectedIndex = 0;
  List<String> categories = ['All', '1 day', '7 day', '1 month'];

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
      Get.to(pages[index]);
    });
  }

  Future<void> _fetchAllTaskStats() async {
    try {
      double totalResult = await _taskController.getTotalTask();
      double completedResult = await _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchOneDayTaskStats() async {
    try {
      double totalResult = await _taskController.getOneDayTask();
      double completedResult = await _taskController.getOneDayCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchSevenDaysTaskStats() async {
    try {
      double totalResult = await _taskController.getTotalTask();
      double completedResult = await _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchOneMonthTaskStats() async {
    try {
      double totalResult = await _taskController.getTotalTask();
      double completedResult = await _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void switchFunc(){
    if (selectedIndex == 0) {
      _fetchAllTaskStats();
    } else if (selectedIndex == 1) {
      _fetchOneDayTaskStats();
    } else if (selectedIndex == 2) {
      _fetchSevenDaysTaskStats();
    } else if (selectedIndex == 3) {
      _fetchOneMonthTaskStats();
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification(); // initialize
    notifyHelper.requestIOSPermissions();
    _fetchAllTaskStats();

    // setState(() {
    //   _taskController.getTasks();
    //   print("Initialize");
    // });
  }

  List pages = [
    const AllTask(),
    const Calendar(),
    const Highlight(),
    const ReportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    print("Report Task Page");

    var todoTasks = totalTask - completedTask;
    print(todoTasks);
    var percent = (completedTask / totalTask * 100).toStringAsFixed(0);
    print(percent);

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
          // todo -- change another image or empty image
          image: Image.asset("assets/Backgrounds/colorful_bg.png").image,
        )),
        child: Column(
          children: [
            _addTaskBar(),
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
                      switchFunc();
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

            // buildStepProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                    //   child: const Divider(thickness: 2),
                    // ),
                    Padding(
                      // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      padding: EdgeInsets.only(
                          top: 10, left: 35, right: 45, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatus(Colors.green, todoTasks, 'Todo Tasks'),
                          _buildStatus(
                              Colors.orange, completedTask, 'Completed Tasks'),
                          _buildStatus(Colors.blue, totalTask, 'Total Tasks'),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: CircularStepProgressIndicator(
                        totalSteps: totalTask == 0 ? 1 : totalTask,
                        currentStep: completedTask,
                        stepSize: 20,
                        selectedColor: Colors.green,
                        unselectedColor: Colors.grey[200],
                        padding: 0,
                        selectedStepSize: 22,
                        roundedCap: (_, __) => true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${totalTask == 0 ? 0 : percent} %',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 1.0),
                            const Text(
                              "Efficiency",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  StepProgressIndicator buildStepProgressIndicator() {
    return StepProgressIndicator(
      totalSteps: 100,
      currentStep: 90,
      // currentStep: homeCtrl.isTodoEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
      size: 5,
      padding: 0,
      selectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blueAccent.withOpacity(0.5), Colors.blueAccent],
      ),
      unselectedGradientColor: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.white],
      ),
    );
  }

  Row _buildStatus(Color color, int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 5.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
    );
  }


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
                  DateFormat.MMMEd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Report",
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


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  int currentIndex = 0;
  int totalTask = 0;
  int completedTask = 0;
  bool isCircular = true;
  ColorTween _colorTween = ColorTween(begin: bluishClr, end: Colors.green);
  double _rotation = 0.0;
  late AnimationController _controller;

  // by default first item will be selected
  int selectedIndex = 0;
  List<String> categories = ['All', '1 day', '7 day', 'This Month'];

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
      double totalResult = await _taskController.getSevenDaysTasks();
      double completedResult =
          await _taskController.getSevenDaysCompletedTasks();

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
      double totalResult = await _taskController.getThisMonthTasks();
      double completedResult = await _taskController.getMonthCompletedTasks();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void switchFunc() {
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
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    // print(todoTasks);
    var percent = (completedTask / totalTask * 100).toStringAsFixed(0);
    // print(percent);

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
                    SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: isCircular
                          ? CircularStepProgressIndicator(
                              selectedColor: bluishClr,
                              totalSteps: totalTask == 0 ? 1 : totalTask,
                              currentStep: completedTask,
                              width: 150,
                              stepSize: 9,
                              roundedCap: (_, isSelected) => isSelected,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${totalTask == 0 ? 0 : percent} %',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                  const SizedBox(height: 1.0),
                                  const Text(
                                    "Efficiency",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : CircularStepProgressIndicator(
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
                    SizedBox(height: 20.0),
                    Padding(
                      // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      padding: EdgeInsets.only(
                          top: 10, left: 35, right: 45, bottom: 10),
                      child: Column(
                        children: [
                          _buildStatus(
                              isCircular
                                  ? bluishClr
                                  : Colors.green,
                              completedTask,
                              'Completed Tasks'),
                          _buildStatus(Colors.grey, todoTasks, 'Todo Tasks'),
                          _buildStatus(Colors.blue, totalTask, 'Total Tasks'),
                        ],
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

  Widget _buildStatus(Color color, int number, String text) {
    IconData? iconData;

    if (text.contains('Completed Tasks')) {
      iconData = Icons.check_circle;
    } else if (text.contains('Todo Tasks')) {
      iconData = Icons.list_alt;
    } else if (text.contains('Total Tasks')) {
      iconData = Icons.assignment;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: color,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        iconData,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        // first line text
                        text.split(' ')[0], // first line text
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$number', // second line text
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    text.split(' ')[1], // second line text
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleStyle() {
    setState(() {
      isCircular = !isCircular;
    });
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

          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _colorTween.evaluate(_controller),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            transform: Matrix4.rotationZ(_rotation),
            child: IconButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                  _toggleStyle();
                } else {
                  _controller.forward();
                }
                setState(() {
                  _colorTween = _colorTween ==
                          ColorTween(begin: bluishClr, end: Colors.green)
                      ? ColorTween(begin: Colors.green, end: bluishClr)
                      : ColorTween(begin: bluishClr, end: Colors.green);
                  _rotation = _rotation == 0.0 ? 0.5 : 0.0;
                });
              },
              icon: Icon(
                Icons.swap_horizontal_circle,
                size: 50,
                color: Colors.white,
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

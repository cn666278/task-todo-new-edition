import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_new_edition/services/notification_services.dart';
import 'package:todo_app_new_edition/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
// update from 2023/02/09
class _HomePageState extends State<HomePage> {
  var notifyHelper;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification(); // 初始化
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Text("Theme Data",
          style: TextStyle(
            fontSize: 30
          ),)
        ],
      ),
    );
  }
  
  _appBar(){
    return AppBar(
      elevation: 0, // eliminate the shadow of header banner
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme changed",
            body: Get.isDarkMode ? "Activated Light Theme" : "Activated Dark Theme",
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
        SizedBox(width: 20,)
      ],
    );
  }
}

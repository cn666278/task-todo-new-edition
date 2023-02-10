import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0, // eliminate the shadow of header banner
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back(); // back to previous page
        },
        child: Icon(Icons.arrow_back_ios,
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

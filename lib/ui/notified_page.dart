import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
          title: Text(
            this.label.toString().split("|")[0],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              color: Get.isDarkMode ? Colors.white:Colors.grey[400]
            ),
            child: Padding(
              // TODO --- ADD MORE INFO: TIME/ DDL / ...
              padding: const EdgeInsets.only(left: 80,top: 15),
              child: Text(
                label.toString().split("|")[1],
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.black:Colors.white,
                  fontSize: 26
                ),
              ),
            ),
          ),
        ));
  }
}

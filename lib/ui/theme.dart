import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color deepOrange = Colors.deepOrange;
Color darkHeaderClr = const Color(0xFF424242);

class Themes {
  // ThemeData used to change the color, style ..
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    // used to change the bar and main page bottom color
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    primaryColor: darkGreyClr,
    // used to change the bar and main page bottom color
    brightness: Brightness.dark,
  );
}

/*
* public method: you can call it anywhere of the whole project
* */
TextStyle get subHeadingStyle {
  // here you can change any font style you like with GoogleFonts.lato
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[500] : Colors.grey,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 29,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

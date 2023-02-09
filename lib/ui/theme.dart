import 'package:flutter/material.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color deepOrange = Colors.deepOrange;
Color darkHeaderClr = const Color(0xFF424242);

class Themes{
    // ThemeData used to change the color, style ..
    static final light = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: primaryClr, // used to change the bar and main page bottom color
      brightness: Brightness.light,
    );

    static final dark =  ThemeData(
      backgroundColor: darkGreyClr,
      primaryColor: darkGreyClr, // used to change the bar and main page bottom color
      brightness: Brightness.dark,
    );
}
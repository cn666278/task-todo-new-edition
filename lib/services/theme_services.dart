import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices{
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // _key存在，返回TRUE，
  // _key不存在，返回FALSE
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // _loadThemeFromBox is TRUE, return ThemeMode.dark.
  // _loadThemeFromBox is FALSE, return ThemeMode.light.
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // initially _loadThemeFromBox() will return false, it means switch to ThmeMode.light
  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    // initially _loadThemeFromBox() will return false, then _saveThemeToBox will return true to isDarkMode(Switch to Dark Mode)
  }
}
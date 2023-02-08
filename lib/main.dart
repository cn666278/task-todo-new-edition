import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app_new_edition/services/theme_services.dart';
import 'package:todo_app_new_edition/ui/home_page.dart';
import 'package:todo_app_new_edition/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // close the debug banner
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,

      home: HomePage()
    );
  }
}


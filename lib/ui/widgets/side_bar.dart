import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_new_edition/models/menu.dart';
import 'package:todo_app_new_edition/ui/add_task_bar.dart';
import 'package:todo_app_new_edition/ui/screens/home_page.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/all_task.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/calendar.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/entry_point.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/highlight.dart';
import 'package:todo_app_new_edition/utils/rive_utils.dart';

import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;
  int currentIndex = 0;

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
      Get.to(pages[index]);
    });
  }

  List pages = [
    const EntryPoint(),
    const AllTask(),
    const Highlight(),
    const Calendar(),
    const EntryPoint(), // ReportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoCard(
                // todo -- add the TABLE - User
                name: "XMUM",
                bio: "Student",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.changeSMIBoolState(menu.rive.status!);
                          setState(() {
                            int index;
                            selectedSideMenu = menu;
                            if (selectedSideMenu.title == "Home") {
                              index = 0;
                            } else if (selectedSideMenu.title == "Search") {
                              // todo -- search page
                              index = 1;
                            } else if (selectedSideMenu.title == "Favorites") {
                              index = 2;
                            } else if (selectedSideMenu.title == "My day") {
                              index = 3;
                            } else {
                              index = -1;
                            }
                            onIndexChanged(index);
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "My day".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.changeSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "Theme Mode".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus3
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.changeSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                            Get.defaultDialog(
                              title: "Developer",
                              middleText: "Chen Nuo",
                            );
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_new_edition/models/menu.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/calendar.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/entry_point.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/highlight.dart';
import 'package:todo_app_new_edition/ui/screens/side_bar_entry/search.dart';
import 'package:todo_app_new_edition/utils/rive_utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
    const Calendar(),
    const Search(),
    const Highlight(),
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    bioController = TextEditingController();
    // todo -- error?
    // initialize name and bio
    nameController.text = "Steven";
    bioController.text = "Flutter Developer";
  }

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
              InfoCard(
                name: TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onTap: () {
                    // 初始化控制器并设置初始值
                    nameController = TextEditingController(text: "Steven");

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit Name'),
                        content: TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // Update the name here
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                bio: TextFormField(
                  controller: bioController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onTap: () {
                    // 初始化控制器并设置初始值
                    bioController = TextEditingController(text: "Flutter Developer");

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit Bio'),
                        content: TextFormField(
                          controller: bioController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // Update the bio here
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
                            } else if (selectedSideMenu.title == "My day") {
                              index = 1;
                            } else if (selectedSideMenu.title == "Search") {
                              index = 2;
                            } else if (selectedSideMenu.title == "Favorites") {
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
                  "Other".toUpperCase(),
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
                            Get.dialog(
                              AlertDialog(
                                title: Row(
                                  children: const [
                                    Icon(Icons.file_copy_outlined),
                                    SizedBox(width: 10),
                                    Text("Github Repository"),
                                  ],
                                ),
                                content: Text(
                                    'https://github.com/cn666278/task-todo-new-edition'),
                                actions: [
                                  TextButton(
                                    child: Text('Access'),
                                    onPressed: () async {
                                      final url = Uri.parse(
                                          'https://github.com/cn666278/task-todo-new-edition');
                                      if (!await launchUrl(url)) {
                                        throw Exception(
                                            'Could not launch $url');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
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
                  "About".toUpperCase(),
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rive/rive.dart';
import 'package:todo_app_new_edition/models/menu.dart';
import 'package:todo_app_new_edition/ui/add_task_bar.dart';
import 'package:todo_app_new_edition/ui/screens/calendar_page.dart';
import 'package:todo_app_new_edition/ui/screens/demo.dart';
import 'package:todo_app_new_edition/ui/theme.dart';
import 'package:todo_app_new_edition/ui/widgets/btm_nav/navigation.dart';
import 'package:todo_app_new_edition/ui/widgets/btm_nav_item.dart';
import 'package:todo_app_new_edition/ui/widgets/menu_btn.dart';
import 'package:todo_app_new_edition/ui/widgets/side_bar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

  late SMIBool isMenuOpenInput;

  // TODO -- NEW ADDED
  final PageController pageController = PageController();
  int currentIndex = 0;

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
            () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideBar(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: CalendarPage(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(
                      () {
                    isSideBarOpen = !isSideBarOpen;
                  },
                );
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(
                    artboard, "State Machine");

                artboard.addController(controller!);

                isMenuOpenInput =
                controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
        ],
      ),

      // TODO --DELETE( old menu bar with no Page jump)
      // bottomNavigationBar: Transform.translate(
      //   offset: Offset(0, 100 * animation.value),
      //   child: SafeArea(
      //     child: Container(
      //       padding:
      //       const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
      //       margin: const EdgeInsets.symmetric(horizontal: 24),
      //       decoration: BoxDecoration(
      //         color: backgroundColor2.withOpacity(0.8),
      //         borderRadius: const BorderRadius.all(Radius.circular(24)),
      //         boxShadow: [
      //           BoxShadow(
      //             color: backgroundColor2.withOpacity(0.3),
      //             offset: const Offset(0, 20),
      //             blurRadius: 20,
      //           ),
      //         ],
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           ...List.generate(
      //             bottomNavItems.length,
      //                 (index) {
      //               Menu navBar = bottomNavItems[index];
      //               return BtmNavItem(
      //                 navBar: navBar,
      //                 press: () {
      //                   RiveUtils.changeSMIBoolState(navBar.rive.status!);
      //                   updateSelectedBtmNav(navBar);
      //                 },
      //                 riveOnInit: (artboard) {
      //                   navBar.rive.status = RiveUtils.getRiveInput(artboard,
      //                       stateMachineName: navBar.rive.stateMachineName);
      //                 },
      //                 selectedNav: selectedBottonNav,
      //               );
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_new_edition/ui/widgets/btm_nav/icon.dart';
import 'package:todo_app_new_edition/utils/theme.dart';

class BuildNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavigationItemModel> items;
  final Function(int) onTap;

  const BuildNavigation({
    Key? key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = <Widget>[];
    var theme = Theme.of(context).bottomNavigationBarTheme;
    for (var i = 0; i < items.length; i++) {
      var color = currentIndex == i
          ? theme.selectedItemColor
          : theme.unselectedItemColor;
      var gap = (items.length / 2).ceil();
      if (gap == i) ws.add(const SizedBox(width: 60));
      ws.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(currentIndex == i ? 5.0 : 0.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: currentIndex == i ? bluishClr : null,
                  ),
                  child: Transform.scale(
                    scale: currentIndex == i ? 1.1 : 1.0,
                    child: Column(
                      children: [
                        SvgIconWidget(
                          items[i].icon,
                          size: 20,
                          color: currentIndex != i ? color : Colors.white,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          items[i].label,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: currentIndex != i ? bluishClr : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return BottomAppBar(
      color: theme.backgroundColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(children: ws),
      ),
    );
  }
}

class NavigationItemModel {
  final String label;
  final String icon;
  final int count;

  NavigationItemModel({
    required this.label,
    required this.icon,
    this.count = 0,
  });
}

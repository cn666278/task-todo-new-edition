import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_new_edition/utils/theme.dart';


class UpdateButton extends StatelessWidget {
  final String label;
  final Function()? onTap; // you are not sure whether get this function or not, if doesn't get just keep it null
  const UpdateButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: primaryClr,
        ),
        child: Padding(
          // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

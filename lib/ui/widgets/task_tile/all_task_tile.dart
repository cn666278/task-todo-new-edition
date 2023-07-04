import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_new_edition/controllers/task_controller.dart';
import 'package:todo_app_new_edition/models/task.dart';
import 'package:todo_app_new_edition/utils/theme.dart';
import 'package:flutter_icons/flutter_icons.dart';

/* This file used for the tasks list(in all category) UI design */
class AllTaskTile extends StatelessWidget {
  final Task? task;

  AllTaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              autoClose: true,
              flex: 2,
              onPressed: task!.isStar == 1 ? undoStarTask : starTask,
              backgroundColor:
              task!.isStar == 1 ? Colors.red[400]! : Colors.green[400]!,
              // backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: task!.isStar == 1 ? Icons.star_border : Icons.star,
              label: task!.isStar == 1 ? 'Undo Star' : 'Star',
              borderRadius: BorderRadius.circular(16),
            ),
            // SlidableAction(
            //   onPressed: doNothing,
            //   backgroundColor: Color(0xFF0392CF),
            //   foregroundColor: Colors.white,
            //   icon: Icons.save,
            //   label: 'Save',
            // ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: Container(
          padding: EdgeInsets.all(16),
          //  width: SizeConfig.screenWidth * 0.78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGClr(task?.color ?? 0),
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  task!.isStar == 1
                      ? Row(
                    children: [
                      Icon(
                        FlutterIcons.star_face_mco,
                        color: Colors.yellow[500],
                        size: 22,
                      ),
                      // Icon(
                      //   Icons.star,
                      //   color: Colors.white,
                      // ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        task?.title ?? "",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )
                      : Text(
                    task?.title ?? "",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        // "${task!.startTime} - ${task!.endTime}",
                        "${task!.startTime} - ${task!.date}",
                        style: GoogleFonts.lato(
                          textStyle:
                          TextStyle(fontSize: 13, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 12),
                  // Text(
                  //   task?.note ?? "",
                  //   style: GoogleFonts.lato(
                  //     textStyle:
                  //     TextStyle(fontSize: 15, color: Colors.grey[100]),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task!.isCompleted == 1 ? "COMPLETED" : "TODO",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void starTask(BuildContext context) {
    final taskController = Get.put(TaskController());
    taskController.markTaskStar(task!.id!); // mark star
  }

  void undoStarTask(BuildContext context) {
    final taskController = Get.put(TaskController());
    taskController.undoTaskStar(task!.id!); // mark star
  }

  /* Control the color of TASK LIST */
  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      case 3:
        return deepOrange;
      default:
        return bluishClr;
    }
  }
}

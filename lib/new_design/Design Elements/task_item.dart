import 'package:flutter/material.dart';
import 'package:test_project/new_design/Pages/to_do_page.dart';

import '../../services/firebase_services.dart';

class TaskItem extends StatelessWidget {
  TaskItem({
    Key? key,
    required this.width,
    required this.task,
    required this.index,
    required this.listLength,
    required this.scrollController,
    required this.animationController,
    // required this.toggleBlurBackground
  }) : super(key: key);

  final double width;
  final Task task;
  final int index;
  final int listLength;
  final ScrollController scrollController;
  final AnimationController animationController;
  // final VoidCallback toggleBlurBackground;

  late final DateTime date = DateTime.fromMillisecondsSinceEpoch(task.dueDate);

  @override
  Widget build(BuildContext context) {
    int timeRemainingMilliseconds =
        task.dueDate - DateTime.now().millisecondsSinceEpoch;
    int timeRemainingDays =
        (timeRemainingMilliseconds.toDouble() ~/ (86400000)) + 1;

    String pastOrPresent() {
      String pastOrPresentString = '';
      if (timeRemainingDays < 0) {
        pastOrPresentString = ' Ago';
      }
      return pastOrPresentString;
    }

    String singularOrPlural() {
      String singularOrPluralString = '';
      if (timeRemainingDays != 1 && timeRemainingDays != -1) {
        singularOrPluralString = 's';
      }
      return singularOrPluralString;
    }

    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () async {
          print(index);
          if (index == 0) {
            await scrollController.animateTo(0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
            animationController.forward();
          } else if (index == listLength - 1) {
            await scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
            animationController.forward();
          } else {
            await scrollController.animateTo((index) * 180,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn);
            animationController.forward();
          }
          toggleSubjectFocus(task);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30, right: 30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: width,
                minHeight: 150,
                maxWidth: width,
                maxHeight: 150),
            child: Dismissible(
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  deleteTaskData(task);
                } else if (direction == DismissDirection.startToEnd &&
                    !task.completed) {
                  taskCompleted(task);
                }
              },
              key: UniqueKey(),
              secondaryBackground: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                    child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.red),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 46,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ),
              background: task.completed
                  ? const SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                          child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.green),
                        child: SizedBox(
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 46,
                                ),
                              ),
                              Text('Completed',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )),
                    ),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(.5, .5),
                          blurRadius: 5,
                          spreadRadius: 1.5)
                    ],
                    border: Border.all(
                        color: Colors.black26,
                        style: BorderStyle.solid,
                        width: 0.5),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18, left: 12, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 4, top: 12, bottom: 12),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SizedBox(
                            height: 30,
                            width: 100,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                task.subject,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width - 140,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              task.name,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              task.details,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 14),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    date.year.toString() +
                                        '-' +
                                        date.month.toString() +
                                        '-' +
                                        date.day.toString() +
                                        ' | ' +
                                        timeRemainingDays.abs().toString() +
                                        ' Day' +
                                        singularOrPlural() +
                                        pastOrPresent(),
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                            Text(
                              'Time Spent: ' +
                                  task.timeSpent.toString() +
                                  ' mins',
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

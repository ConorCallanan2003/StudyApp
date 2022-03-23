import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/new_design/Design%20Elements/list_of_tasks.dart';
import 'package:test_project/new_design/Design%20Elements/task_item.dart';
import 'package:test_project/new_design/Pages/Focus%20Timer/study_timer_page.dart';
import 'package:test_project/services/services.dart';

import '../../services/firebase_services.dart';
import '../Pages/Study Plan/calendar.dart';

class AddSubjectHorizontalScrollItem extends StatefulWidget {
  const AddSubjectHorizontalScrollItem({Key? key}) : super(key: key);

  @override
  State<AddSubjectHorizontalScrollItem> createState() =>
      _AddSubjectHorizontalScrollItemState();
}

class _AddSubjectHorizontalScrollItemState
    extends State<AddSubjectHorizontalScrollItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 12),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black26,
                        style: BorderStyle.solid,
                        width: .2),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.black87,
                  ),
                ))));
  }
}

class TaskSelector extends StatefulWidget {
  const TaskSelector({Key? key}) : super(key: key);

  @override
  State<TaskSelector> createState() => _TaskSelectorState();
}

class _TaskSelectorState extends State<TaskSelector> {
  ValueNotifier<dynamic> task = ValueNotifier<dynamic>(Task(
      id: '', name: '', subject: '', details: '', dueDate: 0, timeSpent: 0));
  var selectedValue;
  // void _setDropdownState() {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getToDoList(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // Map taskNames = {};
        List<DropdownMenuItem> items = [];

        // if (snapshot.hasData) {
        //   // String selectedValue = snapshot.data[0].name;
        // }
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data[0].length; i++) {
            if (snapshot.data[0][i].completed == false) {
              // taskNames[snapshot.data[i].name] = snapshot.data[i].id;
              items.add(DropdownMenuItem(
                value: snapshot.data[0][i],
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          color: Colors.black,
                          width: .2,
                          style: BorderStyle.solid)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Center(
                      child: Text(
                        snapshot.data[0][i].name,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ));
            }
          }
          if (snapshot.data[1] != null) {
            for (var i = 0; i < snapshot.data[1].length; i++) {
              items.add(DropdownMenuItem(
                value: snapshot.data[1][i],
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          color: Colors.black,
                          width: .2,
                          style: BorderStyle.solid)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Center(
                      child: Text(
                        snapshot.data[1][i].subject.name + ' Study',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ));
            }
          }
          return ValueListenableBuilder(
              valueListenable: task,
              builder: (context, var value, Widget? child) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(.5, .5),
                              blurRadius: 5,
                              spreadRadius: 1.5)
                        ],
                      ),
                      child: DropdownButton<dynamic>(
                          dropdownColor: Colors.transparent,
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Center(
                              child: Text(
                                'Choose Task',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                          iconSize: 0,
                          isExpanded: true,
                          value: selectedValue,
                          elevation: 0,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.w300),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (value) {
                            selectedValue = value;
                            task.value = value;
                            setSelectedTask(value);
                          },
                          items: items)),
                );
              });
        } else {
          return const Text('Please Create a Task');
        }
      },
    );
  }
}

String dateFormatter(DateTime date) {
  String formattedDate = date.day.toString() +
      '-' +
      date.month.toString() +
      '-' +
      date.year.toString();

  return formattedDate;
}

String timeFormatter(DateTime time) {
  int minutes = time.minute;
  String formattedMinutes = minutes.toString();
  if (minutes < 10) {
    formattedMinutes = '0' + formattedMinutes;
  }
  int hours = time.hour;
  String formattedHours = hours.toString();
  if (hours < 10) {
    formattedHours = '0' + formattedHours;
  }
  String formattedTime = formattedHours + ':' + formattedMinutes;
  return formattedTime;
}

void addDayOffDialog(BuildContext context, List<DateTime> daysOff, callBack) {
  // List<DateTime> oldDaysOff = daysOff;
  // List<DateTime> newDaysOff = oldDaysOff;
  ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  showDialog(
      context: context,
      builder: (BuildContext c) {
        return AlertDialog(
          title: const Text(
            'Add a Day Off',
            style: TextStyle(fontSize: 18),
          ),
          content: SizedBox(
            height: 60,
            width: 240,
            child: Center(
              child: ValueListenableBuilder(
                  valueListenable: date,
                  builder: (context, value, child) {
                    return TextButton(
                      child: Text(
                        dateFormatter(date.value),
                        style: TextStyle(fontSize: 28, color: Colors.black87),
                      ),
                      onPressed: () async {
                        var newDate = await showDialog(
                            context: context,
                            builder: (BuildContext c) {
                              return MyCalendarDatePicker(
                                  initialDateTime: date.value,
                                  startOrEnd: 'Start');
                            });
                        if (newDate is DateTime) {
                          date.value = newDate;
                        }
                      },
                    );
                  }),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  daysOff.add(date.value);
                  callBack();
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('Add'))
          ],
        );
      });
  // return newDaysOff;
}

int changePreferredSessionLengthDialog(
    BuildContext context, int preferredSessionLength, callBack) {
  // List<DateTime> newDaysOff = oldDaysOff;

  TextEditingController controller = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext c) {
        controller.text = preferredSessionLength.toString();
        return Dialog(
            child: SizedBox(
          height: 200,
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Text('Preferred Session Length in Mins: '),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    print(preferredSessionLength);
                    callBack();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Save'))
            ],
          ),
        ));
      });
  if (int.parse(controller.text) is int && controller.text != null) {
    return int.parse(controller.text);
  } else {
    return preferredSessionLength;
  }
}

confirmDeleteStudyPlanDialog(BuildContext context) async {
  bool exists = await doesStudyPlanExist();

  return exists
      ? showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'Are you sure you want to delete the current study plan?'),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop;
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () async {
                            deleteStudyPlan();

                            Navigator.of(context).pop;
                          },
                          child: const Text('Yes')),
                    ],
                  )
                ],
              ),
            );
          })
      : showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('No Study Plan Found'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please Create a Study Plan'),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop;
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop;
                          },
                          child: const Text('Yes')),
                    ],
                  )
                ],
              ),
            );
          });
}

class AudioSelector extends StatefulWidget {
  AudioSelector({Key? key, required this.audioNames}) : super(key: key);

  List<String> audioNames;

  @override
  State<AudioSelector> createState() => _AudioSelectorState();
}

class _AudioSelectorState extends State<AudioSelector> {
  ValueNotifier<String> audio = ValueNotifier<String>('');
  String? selectedValue;
  // void _setDropdownState() {}

  @override
  Widget build(BuildContext context) {
    List<String> audioNames = widget.audioNames;

    return ValueListenableBuilder(
        valueListenable: audio,
        builder: (context, String value, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(.5, .5),
                        blurRadius: 5,
                        spreadRadius: 1.5)
                  ],
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.transparent,
                  hint: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Center(
                      child: Text(
                        'Choose Audio',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  iconSize: 0,
                  isExpanded: true,
                  value: selectedValue,
                  elevation: 0,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (value) {
                    selectedValue = value as String;
                    audio.value = value;
                    // setSelectedAudio(value);
                  },
                  items: audioNames
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                      color: Colors.black,
                                      width: .2,
                                      style: BorderStyle.solid)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Center(
                                  child: Text(
                                    e,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                )),
          );
        });
  }
}

// class StudyItem extends StatelessWidget {
//   StudyItem({Key? key, required this.studyPeriod}) : super(key: key);

//   NonStorableStudyPeriod studyPeriod;

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Container(
//         width: width,
//         height: 80,
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(12),
//             ),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.white38,
//                   offset: Offset(2.5, 2.5),
//                   blurRadius: 5)
//             ]),
//         child: Center(child: Text(studyPeriod.subject.name)),
//       ),
//     );
//   }
// }

class StudyItem extends StatelessWidget {
  const StudyItem({
    Key? key,
    required this.width,
    required this.studyPeriod,

    // required this.toggleBlurBackground
  }) : super(key: key);

  final double width;
  final NonStorableStudyPeriod studyPeriod;

  @override
  Widget build(BuildContext context) {
    final Task task = studyPeriodToTask(studyPeriod);
    // DateTime date = DateTime.fromMillisecondsSinceEpoch(task.dueDate);
    // int timeRemainingMilliseconds =
    //     task.dueDate - DateTime.now().millisecondsSinceEpoch;
    // int timeRemainingDays =
    //     (timeRemainingMilliseconds.toDouble() ~/ (86400000)) + 1;
    return SliverToBoxAdapter(
        child: GestureDetector(
            onTap: () async {},
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 30, right: 30),
              child: SizedBox(
                width: width,
                height: 120,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
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
                              width: 80,
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
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:test_project/new_design/Pages/Study%20Plan/calendar.dart';
import 'package:test_project/services/firebase_services.dart';

Future<void> addTaskDialogue(BuildContext context) async {
  final taskNameController = TextEditingController();
  final taskDetailsController = TextEditingController();

  ValueNotifier<String> subject = ValueNotifier<String>('');

  void _setDropdownState() {}

  ValueNotifier<DateTime> dueDate = ValueNotifier<DateTime>(DateTime.now());

  String? selectedValue;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text('Add New Task'),
        content: SizedBox(
          height: 250,
          width: 180,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Task Name',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w200),
                ),
                controller: taskNameController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                      valueListenable: dueDate,
                      builder: (context, DateTime value, Widget? child) {
                        return TextButton(
                          onPressed: () async {
                            // DatePicker.showDatePicker(context,
                            //     showTitleActions: true,
                            //     minTime: DateTime.now(),
                            //     maxTime: null, onChanged: (date) {
                            //   dueDate.value = date;
                            // }, onConfirm: (date) {
                            //   dueDate.value = date;
                            // },
                            //     currentTime: DateTime.now(),
                            //     locale: LocaleType.en);
                            var newDate = await showDialog(
                                context: context,
                                builder: (BuildContext c) {
                                  return MyCalendarDatePicker(
                                      initialDateTime: dueDate.value,
                                      startOrEnd: 'Start');
                                });
                            if (newDate is DateTime) {
                              dueDate.value = newDate;
                            }
                          },
                          child: Text(
                              'Due Date: ' +
                                  dueDate.value.year.toString() +
                                  '-' +
                                  dueDate.value.month.toString() +
                                  '-' +
                                  dueDate.value.day.toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300)),
                        );
                      }),
                ],
              ),
              FutureBuilder(
                future: getSubjectsFB(),
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<String> subjectNames = [];

                  if (snapshot.hasData) {
                    // String selectedValue = snapshot.data[0].name;
                  }
                  if (snapshot.hasData) {
                    for (var i = 0; i < snapshot.data.length; i++) {
                      subjectNames.add(snapshot.data[i].name);
                    }
                    return ValueListenableBuilder(
                        valueListenable: subject,
                        builder: (context, String value, Widget? child) {
                          return DropdownButton<String>(
                            hint: const Text('Subject'),
                            iconSize: 0,
                            isExpanded: true,
                            value: selectedValue,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.w300),
                            underline: Container(
                              height: 0,
                            ),
                            onChanged: (value) {
                              selectedValue = value as String;
                              subject.value = value;
                              _setDropdownState();
                            },
                            items: subjectNames
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            color: Colors.black87),
                                      ),
                                    ))
                                .toList(),
                          );
                        });
                  } else {
                    return const Text('Please Create a Subject');
                  }
                },
              ),
              SizedBox(
                height: 100,
                child: TextField(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: taskDetailsController,
                  decoration: const InputDecoration(
                    hintText: 'Task Details',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.tealAccent, fontSize: 20),
            ),
            onPressed: () async {
              String confirmAdded = await addTaskData(Task(
                  id: '',
                  name: taskNameController.text,
                  subject: subject.value,
                  details: taskDetailsController.text,
                  dueDate: dueDate.value.millisecondsSinceEpoch,
                  timeSpent: 0));

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

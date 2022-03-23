import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:test_project/new_design/Pages/Study%20Plan/calendar.dart';
import 'package:test_project/new_design/Design%20Elements/dialogues.dart/confirm_task_delete_dialogue.dart';
import 'package:test_project/services/firebase_services.dart';

class FocusedTaskWidget extends StatefulWidget {
  const FocusedTaskWidget({
    Key? key,
    required this.task,
    required this.callback,
    required this.animation,
  }) : super(key: key);

  final Task task;

  final VoidCallback callback;

  final Animation animation;

  @override
  State<FocusedTaskWidget> createState() => _FocusedTaskWidgetState();
}

class _FocusedTaskWidgetState extends State<FocusedTaskWidget> {
  late final DateTime date =
      DateTime.fromMillisecondsSinceEpoch(widget.task.dueDate);

  late final nameController = TextEditingController();

  late final detailsController = TextEditingController();

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<DateTime> dueDate = ValueNotifier<DateTime>(
        DateTime.fromMillisecondsSinceEpoch(widget.task.dueDate));
    ValueNotifier<String> subject = ValueNotifier<String>(widget.task.subject);
    nameController.text = widget.task.name;
    detailsController.text = widget.task.details;
    return Transform.translate(
      offset: Offset(0, (-50 * (1 - widget.animation.value)).toDouble()),
      child: SizedBox(
          height: (widget.animation.value * 450 > 160)
              ? widget.animation.value * 450
              : 160,
          width: 316,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: (widget.animation.value * 350 > 160)
                    ? widget.animation.value * 350
                    : 160,
                width: 316,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(.5, .5),
                          blurRadius: 5,
                          spreadRadius: 1.5)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        style: TextStyle(
                            color: Colors.black
                                .withOpacity(widget.animation.value * .87),
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Container(
                          width: 280,
                          height: 2,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)),
                              color: Colors.black),
                        ),
                      ),
                      FutureBuilder(
                        future: getSubjectsFB(),
                        initialData: null,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<String> subjectNames = [];
                          if (snapshot.hasData) {
                            for (var i = 0; i < snapshot.data.length; i++) {
                              subjectNames.add(snapshot.data[i].name);
                            }
                            return ValueListenableBuilder(
                                valueListenable: subject,
                                builder:
                                    (context, String value, Widget? child) {
                                  selectedValue = value;
                                  return DropdownButton<String>(
                                    hint: Text(
                                      'Subject',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(
                                              widget.animation.value * 1)),
                                    ),
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
                                    },
                                    items: subjectNames
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(widget
                                                                .animation
                                                                .value *
                                                            .87)),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Container(
                          width: 280,
                          height: 1,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1)),
                              color: Colors.black
                                  .withOpacity(widget.animation.value * 1)),
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: TextField(
                          controller: detailsController,
                          style: TextStyle(
                            color: Colors.black.withOpacity(
                                widget.animation.value == 1 ? .8 : 0),
                            fontSize: 18,
                          ),
                          expands: true,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      const Spacer(),
                      ValueListenableBuilder(
                          valueListenable: dueDate,
                          builder: (context, DateTime value, Widget? child) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: TextButton(
                                onPressed: () async {
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
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(
                                            widget.animation.value == 1
                                                ? .8
                                                : 0),
                                        fontWeight: FontWeight.w300)),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              widget.animation.value == 1
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // var deleteCheck = await deleteTaskData(widget.task);
                            await confirmTaskDelete(context, widget.task);
                            widget.callback();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Container(
                              height: 50,
                              width: 130,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(1.5, 1.5),
                                      color: Colors.black26,
                                      blurRadius: 2.5,
                                      spreadRadius: 1.5,
                                    )
                                  ],
                                  border: Border.all(
                                      color: Colors.black87, width: .2),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.red),
                              child: const Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await updateTaskData(Task(
                                id: widget.task.id,
                                name: nameController.text,
                                subject: subject.value,
                                details: detailsController.text,
                                dueDate: dueDate.value.millisecondsSinceEpoch,
                                completed: widget.task.completed,
                                timeSpent: widget.task.timeSpent));
                            widget.callback();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                              height: 50,
                              width: 130,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(1.5, 1.5),
                                      color: Colors.black26,
                                      blurRadius: 2.5,
                                      spreadRadius: 1.5,
                                    )
                                  ],
                                  border: Border.all(
                                      color: Colors.black87, width: .2),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(width: 0, height: 0)
            ],
          )),
    );
  }
}

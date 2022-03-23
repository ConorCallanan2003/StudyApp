import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/new_design/Design%20Elements/dialogues.dart/add_subject_dialogue.dart';
import 'package:test_project/new_design/Design%20Elements/focused_task.dart';
import 'package:test_project/new_design/Design%20Elements/list_of_tasks.dart';
import 'package:test_project/new_design/Design%20Elements/small_elements.dart';
import 'package:test_project/new_design/Design%20Elements/subject_horizontal_scroll.dart';
import 'package:test_project/services/auth.dart';
import 'package:test_project/services/firebase_services.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key, required this.blurBackground}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final blurBackground;

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

Task focusedTask =
    Task(id: '', name: '', subject: '', details: '', dueDate: 0, timeSpent: 0);

void toggleSubjectFocus(Task task) {
  focusedTask = task;
}

class _ToDoPageState extends State<ToDoPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> heightAnimation;
  late Animation<double> widthAnimation;

  late AnimationController controller;

  ValueNotifier<int> selectedIndex = ValueNotifier<int>(-1);
  ValueNotifier<String> selectedSubject = ValueNotifier<String>('All');

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    heightAnimation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    widthAnimation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    if (widget.blurBackground.value) {
      controller.forward();
      print('forward');
    } else {
      controller.reverse();
    }
  }

  void blurCallback() {
    widget.blurBackground.value = false;
    if (widget.blurBackground.value && widthAnimation.value == 0) {
      controller.forward();
      print('forward');
    }
    if (!widget.blurBackground.value && widthAnimation.value == 1) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, int value, Widget? child) {
          return Stack(
            children: [
              Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 217, 244, 255),
                  Color.fromARGB(255, 177, 226, 247)
                ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
                child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Padding(
                                padding: EdgeInsets.only(top: 28, left: 24),
                                child: Text(
                                  'Hello,',
                                  style: TextStyle(
                                      fontSize: 34,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          IconButton(
                              onPressed: () => FirebaseAuth.instance.signOut(),
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.black,
                                size: 34,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              getDisplayName() + ' 👋',
                              style: const TextStyle(
                                  fontSize: 38,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 50,
                        width: width,
                        child: FutureBuilder(
                          future: getSubjectsFB(),
                          initialData: null,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<Widget> slivers = [
                                const SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 10,
                                    width: 8,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                    child: GestureDetector(
                                  onTap: () {
                                    selectedIndex.value = -1;
                                    selectedSubject.value = 'All';
                                  },
                                  child: ValueListenableBuilder<int>(
                                      valueListenable: selectedIndex,
                                      builder: (context, int selectedIndex,
                                          Widget? child) {
                                        return SubjectHorizontalScrollItem(
                                          subject:
                                              Subject(id: '0', name: 'All'),
                                          index: -1,
                                          selectedIndex: selectedIndex,
                                        );
                                      }),
                                ))
                              ];
                              for (var i = 0; i < snapshot.data.length; i++) {
                                slivers.add(SliverToBoxAdapter(
                                    child: GestureDetector(
                                  onLongPress: () =>
                                      deleteSubjectDataFB(snapshot.data[i]),
                                  onTap: () {
                                    selectedIndex.value = i;
                                    selectedSubject.value =
                                        snapshot.data[i].name;
                                  },
                                  child: ValueListenableBuilder<int>(
                                      valueListenable: selectedIndex,
                                      builder: (context, int selectedIndex,
                                          Widget? child) {
                                        return SubjectHorizontalScrollItem(
                                          subject: snapshot.data[i],
                                          index: i,
                                          selectedIndex: selectedIndex,
                                        );
                                      }),
                                )));
                              }
                              slivers.add(SliverToBoxAdapter(
                                child: GestureDetector(
                                  onTap: () {
                                    selectedIndex.value = slivers.length - 2;
                                    selectedSubject.value = 'completed';
                                  },
                                  child: ValueListenableBuilder<int>(
                                    valueListenable: selectedIndex,
                                    builder: (context, int selectedIndex,
                                        Widget? child) {
                                      return SubjectHorizontalScrollItem(
                                        subject:
                                            Subject(id: '', name: 'Completed'),
                                        index: slivers.length - 2,
                                        selectedIndex: selectedIndex,
                                        completed: true,
                                      );
                                    },
                                  ),
                                ),
                              ));
                              slivers.add(SliverToBoxAdapter(
                                  child: GestureDetector(
                                      onTap: () {
                                        addSubjectDialogue(context);
                                      },
                                      child:
                                          const AddSubjectHorizontalScrollItem())));
                              return CustomScrollView(
                                scrollDirection: Axis.horizontal,
                                slivers: slivers,
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text('Create a Subject'),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: selectedSubject,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .8,
                          child: ListOfTasks(
                            subject: value,
                            // blurBackground: () => toggleBlurBackground,
                            animationController: controller,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              widthAnimation.value != 0
                  ? Positioned.fill(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.height,
                        child: GestureDetector(
                          onTap: () => controller.reverse(),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: widthAnimation.value * 2.5,
                                sigmaY: widthAnimation.value * 2.5),
                            child: Container(
                              color: Colors.black
                                  .withOpacity(widthAnimation.value * .25),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              widthAnimation.value != 0
                  ? Center(
                      child: FocusedTaskWidget(
                      task: focusedTask,
                      callback: blurCallback,
                      animation: widthAnimation,
                    ))
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    )
            ],
          );
        });
  }
}

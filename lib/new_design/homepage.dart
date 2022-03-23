import 'package:flutter/material.dart';
import 'package:test_project/new_design/Design%20Elements/dialogues.dart/add_task_dialogue.dart';
import 'package:test_project/new_design/Pages/Focus%20Timer/study_timer_page.dart';
import 'package:test_project/new_design/Pages/to_do_page.dart';
import 'package:test_project/new_design/Pages/Study%20Plan/study_plan_generator.dart';

//Sets the overall layout for the app.

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

ValueNotifier<bool> blurBackground = ValueNotifier<bool>(false);

ValueNotifier<bool> restartTimer = ValueNotifier(false);

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  //The three primary pages of the app.
  List<Widget> pages = [
    ToDoPage(blurBackground: blurBackground),
    const TestPage(),
    ValueListenableBuilder(
      valueListenable: restartTimer,
      builder: (context, value, child) {
        return StudyTimerPage(
          restartTimer: restartTimer,
        );
      },
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Rebuilds the widget when the value of blurBackground changes.
    return ValueListenableBuilder(
        valueListenable: blurBackground,
        builder: (c, bool value, Widget? home) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: null,
            body: pages.elementAt(_selectedIndex),
            //floatingActionButton will only appear on To-Do page.
            floatingActionButton: _selectedIndex == 0
                ? FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.add,
                      color: Colors.black87,
                      size: 32,
                    ),
                    onPressed: () => addTaskDialogue(context),
                  )
                : null,
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: timerActive,
              builder: (context, bool value, child) {
                return value
                    ? SizedBox(
                        height: 0,
                        width: 0,
                      )
                    : Container(
                        height: 70,
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(-.5, -.5),
                                  blurRadius: 5,
                                  spreadRadius: 1.5)
                            ],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(60),
                                topLeft: Radius.circular(60))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(60),
                              topLeft: Radius.circular(60)),
                          child: BottomNavigationBar(
                            selectedItemColor: Colors.black.withOpacity(.9),
                            items: const [
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.task_alt), label: 'To-Do'),
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.book), label: 'Study Plan'),
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.schedule),
                                  label: 'Focus Timer')
                            ],
                            currentIndex: _selectedIndex,
                            onTap: _onItemTapped,
                          ),
                        ),
                      );
              },
            ),
          );
        });
  }
}

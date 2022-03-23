import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/new_design/Pages/Study%20Plan/calendar.dart';
import 'package:test_project/new_design/Design%20Elements/small_elements.dart';
import 'package:test_project/services/firebase_services.dart';
import 'package:test_project/services/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  //Declaring necessary variables. Looks messy but a lot of data needs to be inputted on this page.

  ValueNotifier<DateTime> startDate = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> endDate =
      ValueNotifier<DateTime>(DateTime.now().add(const Duration(days: 7)));
  ValueNotifier<DateTime> startTime = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> endTime =
      ValueNotifier<DateTime>(DateTime.now().add(const Duration(hours: 3)));
  List<StudyPeriod> studyPeriods = [];
  DateTime selectedDate = DateTime.now();
  ValueNotifier<List<Subject>> excludedSubjects = ValueNotifier([]);
  List<Subject> selectedChips = [];
  DateTime daysOffDateSelector = DateTime.now();
  List<DateTime> daysOff = [];
  bool stateBool = false;
  List<StudyPeriod> studyPlan = [];
  TextEditingController preferredSessionLengthController =
      TextEditingController();

  //Creating a callback that will allow the widget to be rebuilt on command.
  void voidCallback() {
    setState(() {});
  }

  //Checks if a list of subjects contains a certain subject.
  bool listContainsSubject(List<Subject> subjects, Subject subject) {
    bool answer = false;
    for (var item in subjects) {
      if (subject.id == item.id) {
        answer = true;
      }
    }
    return answer;
  }

  //Takes a list of subjects, removes a particular subject, and returns a new list. Necessary as the default .remove function in dart won't work for custom objects.
  List<Subject> removeSubjectFromList(List<Subject> oldList, Subject subject) {
    List<Subject> newList = [];
    for (var item in oldList) {
      if (subject.id != item.id) {
        newList.add(item);
      }
    }
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const TabBar(
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Generate',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Calendar',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                ],
                indicatorColor: Colors.black54,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 217, 244, 255),
                Color.fromARGB(255, 177, 226, 247)
              ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: TabBarView(children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: 30, width: width),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: height * .15,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Column(
                              children: [
                                const Text(
                                  'Dates',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Widget will be rebuilt when startDate is changed. This is necessary as otherwise the user would have no way of knowing what date is selected.
                                    ValueListenableBuilder(
                                        valueListenable: startDate,
                                        builder:
                                            (context, DateTime value, child) {
                                          return TextButton(
                                            onPressed: () async {
                                              var newDate = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext c) {
                                                    return MyCalendarDatePicker(
                                                        initialDateTime:
                                                            startDate.value,
                                                        startOrEnd: 'Start');
                                                  });
                                              if (newDate is DateTime) {
                                                startDate.value = newDate;
                                              }
                                            },
                                            child: Text(
                                                'Start: ' +
                                                    startDate.value.day
                                                        .toString() +
                                                    '-' +
                                                    startDate.value.month
                                                        .toString() +
                                                    '-' +
                                                    startDate.value.year
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          );
                                        }),
                                    ValueListenableBuilder(
                                        valueListenable: endDate,
                                        builder:
                                            (context, DateTime value, child) {
                                          return TextButton(
                                            onPressed: () async {
                                              var newDate = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext c) {
                                                    return MyCalendarDatePicker(
                                                        initialDateTime:
                                                            endDate.value,
                                                        startOrEnd: 'Start');
                                                  });
                                              if (newDate is DateTime) {
                                                endDate.value = newDate;
                                              }
                                            },
                                            child: Text(
                                                'End: ' +
                                                    endDate.value.day
                                                        .toString() +
                                                    '-' +
                                                    endDate.value.month
                                                        .toString() +
                                                    '-' +
                                                    endDate.value.year
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          );
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: height * .15,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Column(
                              children: [
                                const Text(
                                  'Times',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable: startTime,
                                        builder:
                                            (context, DateTime value, child) {
                                          return TextButton(
                                            onPressed: () async {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .25,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: Colors.white,
                                                      child:
                                                          CupertinoDatePicker(
                                                        onDateTimeChanged:
                                                            (time) {
                                                          startTime.value =
                                                              time;
                                                        },
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        initialDateTime:
                                                            startTime.value,
                                                        use24hFormat: true,
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Text(
                                                'Start: ' +
                                                    timeFormatter(
                                                        startTime.value),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          );
                                        }),
                                    ValueListenableBuilder(
                                        valueListenable: endTime,
                                        builder:
                                            (context, DateTime value, child) {
                                          return TextButton(
                                            onPressed: () async {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .25,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: Colors.white,
                                                      child:
                                                          CupertinoDatePicker(
                                                        onDateTimeChanged:
                                                            (time) {
                                                          endTime.value = time;
                                                        },
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        initialDateTime:
                                                            endTime.value,
                                                        // minimumDate: DateTime.now(),
                                                        // maximumDate: null,
                                                        use24hFormat: true,
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Text(
                                                'End: ' +
                                                    timeFormatter(
                                                        endTime.value),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          );
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: height * .15,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Column(
                              children: [
                                const Text(
                                  'Subjects',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: FutureBuilder(
                                      future: getSubjectsFB(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: ChoiceChip(
                                                      backgroundColor: Colors
                                                          .white,
                                                      selectedColor: Colors
                                                          .blue,
                                                      label: Text(
                                                        snapshot
                                                            .data[index].name,
                                                        style: TextStyle(
                                                            color: listContainsSubject(
                                                                    selectedChips,
                                                                    snapshot.data[
                                                                        index])
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                      selected:
                                                          listContainsSubject(
                                                              selectedChips,
                                                              snapshot
                                                                  .data[index]),
                                                      onSelected:
                                                          (bool newValue) {
                                                        stateBool = newValue;
                                                        if (listContainsSubject(
                                                            selectedChips,
                                                            snapshot
                                                                .data[index])) {
                                                          selectedChips =
                                                              removeSubjectFromList(
                                                                  selectedChips,
                                                                  snapshot.data[
                                                                      index]);
                                                        } else {
                                                          selectedChips.add(
                                                              snapshot
                                                                  .data[index]);
                                                        }
                                                        setState(() {});
                                                      }),
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                              'Please Add Subjects on To-Do Page');
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: height * .14,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Column(
                              children: [
                                const Text(
                                  'Days Off',
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: daysOff.length + 1,
                                      itemBuilder: (BuildContext context, i) {
                                        if (i == 0) {
                                          return GestureDetector(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: const Icon(Icons.add),
                                              width: 60,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  border: Border.all(
                                                      color: Colors.black54,
                                                      width: 0.2,
                                                      style:
                                                          BorderStyle.solid)),
                                            ),
                                            onTap: () {
                                              addDayOffDialog(context, daysOff,
                                                  voidCallback);
                                              // daysOff.value = newDaysOff;
                                            },
                                          );
                                        }
                                        if (i != 0) {
                                          return GestureDetector(
                                              child: Container(
                                                width: 90,
                                                padding: EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                  child: Text(
                                                    dateFormatter(
                                                        daysOff[i - 1]),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              onLongPress: () {
                                                daysOff.remove(daysOff[i - 1]);
                                                setState(() {});
                                              });
                                        } else {
                                          return const SizedBox(
                                            height: 0,
                                            width: 0,
                                          );
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              const Text('Preferred Session Length in Mins: '),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: preferredSessionLengthController,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                              child: TextButton(
                                  onPressed: () async {
                                    studyPeriods = generateStudyPlan(
                                        StudyPlanParameters(
                                            generateStudyDays(
                                                startDate.value,
                                                endDate.value,
                                                daysOff,
                                                startTime.value,
                                                endTime.value),
                                            selectedChips,
                                            int.parse(
                                                preferredSessionLengthController
                                                    .text)));
                                    addToStudyPlanDB(studyPeriods);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Study Plan Generated'),
                                            content: const Text(
                                                'Your custom study plan has been generated and can now be seen on the calendar.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text('Okay'))
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 8),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(2.5, 2.5),
                                                blurRadius: 5)
                                          ]),
                                      child: const Text('Submit',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20))))),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Calendar(),
                  )
                ]),
              ),
            )));
  }
}

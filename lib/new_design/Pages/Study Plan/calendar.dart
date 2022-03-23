import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_project/new_design/Design%20Elements/small_elements.dart';
import 'package:test_project/services/firebase_services.dart';
import 'package:test_project/services/services.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<NonStorableStudyPeriod>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  // List<NonStorableStudyPeriod> _getEventsfromDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime(1990),
          lastDay: DateTime(2050),
          calendarFormat: format,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekVisible: true,

          //Day Changed
          onDaySelected: (DateTime selectDay, DateTime focusDay) {
            setState(() {
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },

          //To style the Calendar
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedTextStyle: const TextStyle(color: Colors.black),
            todayDecoration: BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            formatButtonTextStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: getStudyPlan(),
              builder: (context, AsyncSnapshot snapshot) {
                double totalHeight = 0;
                ValueNotifier<List<Widget>> slivers = ValueNotifier([]);
                if (snapshot.hasData) {
                  for (NonStorableStudyPeriod studyPeriod in snapshot.data) {
                    print('loop');
                    if (isSameDay(studyPeriod.startTime, selectedDay)) {
                      slivers.value.add(StudyItem(
                        width: MediaQuery.of(context).size.width,
                        studyPeriod: NonStorableStudyPeriod(
                            studyPeriod.id,
                            studyPeriod.startTime,
                            studyPeriod.endTime,
                            studyPeriod.subject,
                            studyPeriod.timeSpent),
                      ));
                      totalHeight += 135;
                    }
                  }
                  slivers.value.add(SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ));
                  return ValueListenableBuilder(
                      valueListenable: slivers,
                      builder: (context, value, child) {
                        return CustomScrollView(slivers: slivers.value);
                      });
                } else {
                  return SizedBox(
                    child: Transform.translate(
                      offset: Offset(0, -50),
                      child: const FittedBox(
                          fit: BoxFit.fitWidth,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          )),
                    ),
                    width: 80,
                    height: 80,
                  );
                }
              }),
        ),
      ],
    );
  }
}

class MyCalendarDatePicker extends StatefulWidget {
  MyCalendarDatePicker(
      {Key? key, required this.initialDateTime, required this.startOrEnd})
      : super(key: key);

  DateTime initialDateTime = DateTime.now();
  String startOrEnd;

  @override
  State<MyCalendarDatePicker> createState() => _MyCalendarDatePickerState();
}

class _MyCalendarDatePickerState extends State<MyCalendarDatePicker> {
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    _selectedDateTime = widget.initialDateTime;
    _selectedDay = widget.initialDateTime;
    super.initState();
  }

  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select ' + widget.startOrEnd + ' Date',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: SizedBox(
        height: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2050),
                  calendarFormat: _format,
                  onFormatChanged: (CalendarFormat _format) {
                    _format = _format;
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekVisible: true,

                  //Day Changed
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    print('onDaySelected' + selectDay.toString());
                    setState((() {
                      _focusedDay = focusDay;
                      _selectedDay = selectDay;
                    }));
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(_selectedDay, date);
                  },
                  calendarStyle: CalendarStyle(
                    outsideTextStyle: const TextStyle(color: Colors.black87),
                    todayTextStyle: const TextStyle(color: Colors.black87),
                    defaultTextStyle: const TextStyle(color: Colors.black87),
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
                height: 240,
                width: 280,
              ),
            ),
            GestureDetector(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2.5, 2.5),
                          spreadRadius: 2.5,
                          blurRadius: 5)
                    ]),
                child: const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              ),
              onTap: () async {
                setState(() {
                  _selectedDateTime = _selectedDay;
                });
                Navigator.pop(context, _selectedDateTime);
              },
            )
          ],
        ),
      ),
    );
  }
}

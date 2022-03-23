import 'package:firebase_database/firebase_database.dart';
import 'package:test_project/services/auth.dart';
import 'dart:async';

import 'package:test_project/services/services.dart';

import '../new_design/Design Elements/small_elements.dart';

class Subject {
  final String id;
  final String name;

  Subject({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Subject{id: $id, name: $name}';
  }
}

//This adds a subject to the realtime cloud
Future<String> addSubjectDataFB(Subject subject) async {
  String result = '';
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/subjects');
  DatabaseReference newRef = reference.push();
  final newKey = newRef.key;
  await newRef.set({"name": subject.name, "id": newKey}).then((_) {
    // var subjects = await getSubjectsFB();
    result = 'Success';
  }).catchError((error) {
    result = error;
  });
  return result;
}

Future<String> deleteSubjectDataFB(Subject subject) async {
  String? _result = '';
  FirebaseDatabase.instance.ref(getUID() + '/subjects/' + subject.id).remove();
  return _result;
}

//This retrieves the user's subjects from the database.
Future<List<Subject>> getSubjectsFB() async {
  List<Subject> subjects = [];
  final ref = FirebaseDatabase.instance.ref(getUID() + '/subjects');
  DataSnapshot snapshot = await ref.get();
  if (snapshot.exists) {
    for (var subject in snapshot.children) {
      subjects.add(Subject(
          id: (subject.value as dynamic)["id"],
          name: (subject.value as dynamic)["name"]));
    }
  } else {}

  return subjects;
}

class Task {
  final String id;
  final String name;
  final String subject;
  final String details;
  final int dueDate;
  final int timeSpent;
  final bool completed;

  Task({
    required this.id,
    required this.name,
    required this.subject,
    required this.details,
    required this.dueDate,
    required this.timeSpent,
    this.completed = false,
  });
}

//Adds a task to the database.
Future<String> addTaskData(Task task) async {
  String result = '';
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/tasks');
  DatabaseReference newRef = reference.push();
  final newKey = newRef.key;
  await newRef.set({
    "id": newKey,
    "name": task.name,
    "subject": task.subject,
    "details": task.details,
    "dueDate": task.dueDate,
    "completed": task.completed,
    "timeSpent": task.timeSpent
  }).then((_) {
    // var subjects = await getSubjectsFB();
    result = 'Success';
  }).catchError((error) {
    result = error;
  });

  return result;
}

//Updates an existing task.
Future<String> updateTaskData(Task task) async {
  String result = '';
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/tasks/' + task.id);
  await reference.set({
    "id": task.id,
    "name": task.name,
    "subject": task.subject,
    "details": task.details,
    "dueDate": task.dueDate,
    "completed": task.completed,
    "timeSpent": task.timeSpent
  }).then((_) {
    // var subjects = await getSubjectsFB();
    result = 'Success';
  }).catchError((error) {
    result = error;
  });

  return result;
}

//Marks a task as completed.
taskCompleted(Task task) async {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/tasks/' + task.id);
  await reference.update({"completed": true});
}

//Returns a list of the user's tasks from the database.
Future<List<Task>> getTasks() async {
  List<Task> tasks = [];
  final ref = FirebaseDatabase.instance.ref();
  DataSnapshot snapshot = await ref.child(getUID() + '/tasks').get();
  if (snapshot.exists) {
    for (var task in snapshot.children) {
      tasks.add(Task(
          id: (task.value as dynamic)["id"],
          name: (task.value as dynamic)["name"],
          subject: (task.value as dynamic)["subject"],
          details: (task.value as dynamic)["details"],
          dueDate: (task.value as dynamic)["dueDate"],
          completed: (task.value as dynamic)["completed"],
          timeSpent: (task.value as dynamic)["timeSpent"]));
    }
  } else {}
  return tasks;
}

//Delete a task.
void deleteTaskData(Task task) async {
  FirebaseDatabase.instance.ref(getUID() + '/tasks/' + task.id).remove();
}

//One of the objects used in generating the study plan.
class StudyPlanParameters {
  final List<StudyDay> studyDays;
  final List<Subject> subjects;
  final int preferredSessionLength;

  StudyPlanParameters(
      this.studyDays, this.subjects, this.preferredSessionLength);
}

//Adds the generated study plan to the database.
Future<String> addToStudyPlanDB(List<StudyPeriod> studyPeriods) async {
  bool exists = await doesStudyPlanExist();

  //This ensures that any old study plan will be completely overwritten.
  if (exists) {
    deleteStudyPlan();
  }

  String result = '';

  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/studyplan');

  //Iterates through the list of study periods that make up the study plan, adding each to the database.
  for (StudyPeriod studyPeriod in studyPeriods) {
    DatabaseReference newRef = reference.push();
    final newKey = newRef.key;
    await newRef.set({
      "id": newKey,
      //The start time and end time must be stored as integers, so they are converted from years/months/days/hours/minutes/etc. to just milliseconds.
      "startTimeInMSSE": studyPeriod.startTimeInMSSE,
      "endTimeInMSSE": studyPeriod.endTimeInMSSE,
      "subjectID": studyPeriod.subjectID,
      "timeSpent": studyPeriod.timeSpent
    }).then((_) {
      // var subjects = await getSubjectsFB();
      result = '';
    }).catchError((error) {
      result = error;
    });
  }

  return result;
}

Future<String> updateStudyPeriodData(NonStorableStudyPeriod studyPeriod) async {
  String result = '';
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/studyplan/' + studyPeriod.id);
  await reference.set({
    "id": studyPeriod.id,
    "subjectID": studyPeriod.subject.id,
    "startTimeInMSSE": studyPeriod.startTime.millisecondsSinceEpoch,
    "endTimeInMSSE": studyPeriod.endTime.millisecondsSinceEpoch,
    "timeSpent": studyPeriod.timeSpent
  }).then((_) {
    // var subjects = await getSubjectsFB();
    result = 'Success';
  }).catchError((error) {
    result = error;
  });

  return result;
}

//Retrieves the study plan as a list of study periods and converts them to a more usable format.
Future<List<NonStorableStudyPeriod>> getStudyPlan() async {
  List<NonStorableStudyPeriod> studyPlan = [];

  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/studyplan');
  DataSnapshot snapshot = await reference.get();
  if (snapshot.exists) {
    for (var studyPeriod in snapshot.children) {
      studyPlan.add(NonStorableStudyPeriod(
          (studyPeriod.value as dynamic)["id"],
          //Start and end time must be converted back to DateTime objects for them to be easily used by the app.
          DateTime.fromMillisecondsSinceEpoch(
              (studyPeriod.value as dynamic)["startTimeInMSSE"]),
          DateTime.fromMillisecondsSinceEpoch(
              (studyPeriod.value as dynamic)["endTimeInMSSE"]),
          await getSubjectFromID((studyPeriod.value as dynamic)["subjectID"]),
          (studyPeriod.value as dynamic)['timeSpent']));
    }
  }
  return studyPlan;
}

Future<List<NonStorableStudyPeriod>> getStudyPlanForToday() async {
  List<NonStorableStudyPeriod> studyPlan = [];
  final DateTime now = DateTime.now();

  final DatabaseReference reference =
      FirebaseDatabase.instance.ref(getUID() + '/studyplan');
  DataSnapshot snapshot = await reference.get();
  if (snapshot.exists) {
    for (var studyPeriod in snapshot.children) {
      if (sameDate(
          DateTime.now(),
          DateTime.fromMillisecondsSinceEpoch(
              (studyPeriod.value as dynamic)["startTimeInMSSE"]))) {
        print('DATETIMES MATCHED');
        studyPlan.add(NonStorableStudyPeriod(
            (studyPeriod.value as dynamic)["id"],
            //Start and end time must be converted back to DateTime objects for them to be easily used by the app.
            DateTime.fromMillisecondsSinceEpoch(
                (studyPeriod.value as dynamic)["startTimeInMSSE"]),
            DateTime.fromMillisecondsSinceEpoch(
                (studyPeriod.value as dynamic)["endTimeInMSSE"]),
            await getSubjectFromID((studyPeriod.value as dynamic)["subjectID"]),
            (studyPeriod.value as dynamic)["timeSpent"]));
      }
    }
  }
  return studyPlan;
}

Future<List<dynamic>> getToDoList() async {
  List<String> subjectsAlreadyMentioned = [];
  List<Task> tasks = await getTasks();
  List<NonStorableStudyPeriod> studyPeriodsToday = await getStudyPlanForToday();
  List<NonStorableStudyPeriod> modifiedStudyPeriodsToday = [];
  for (NonStorableStudyPeriod studyPeriod in studyPeriodsToday) {
    if (!subjectsAlreadyMentioned.contains(studyPeriod.subject.id)) {
      modifiedStudyPeriodsToday.add(studyPeriod);
    }
    subjectsAlreadyMentioned.add(studyPeriod.subject.id);
  }
  List<List> result = [tasks, modifiedStudyPeriodsToday];
  return result;
}

//Deletes existing study plan.
void deleteStudyPlan() async {
  await FirebaseDatabase.instance.ref(getUID() + '/studyplan').remove();
}

class StudyDay {
  DateTime startTime;
  DateTime endTime;

  StudyDay(this.startTime, this.endTime);
}

//These are stored in the database to make up the study plan.
class StudyPeriod {
  final String id;
  //Times must be in int to be stored in the database.
  final int startTimeInMSSE;
  final int endTimeInMSSE;
  //Subject must be a string to be stored in the database.
  final String subjectID;
  final int timeSpent;

  StudyPeriod(this.id, this.startTimeInMSSE, this.endTimeInMSSE, this.subjectID,
      this.timeSpent);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTimeInMSSE,
      'endTime': endTimeInMSSE,
      'subjectID': subjectID,
      'timeSpent': timeSpent,
    };
  }

  // @override
  // String toString() {
  //   return 'Task{id: $id, startTime: $startTimeInMSSE, endTime: $endTimeInMSSE, subjectID: $subjectID}';
  // }
}

//Essentially just StudyPeriod but in a more useful format.
class NonStorableStudyPeriod {
  final String id;
  //Times can be stored as DateTime objects as they don't need to be stored in the database.
  final DateTime startTime;
  final DateTime endTime;
  //Subject can be stored as a subject object.
  final Subject subject;
  final int timeSpent;

  NonStorableStudyPeriod(
      this.id, this.startTime, this.endTime, this.subject, this.timeSpent);
}

//This function works out the dates and times when the user wishes to study.
List<StudyDay> generateStudyDays(DateTime startDate, DateTime endDate,
    List<DateTime> daysOff, DateTime startTime, DateTime endTime) {
  List<StudyDay> studyDays = [];

  int totalDays =
      ((endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch) ~/
              86400000) +
          1;
  for (var i = 0; i < totalDays; i++) {
    DateTime date = startDate.add(Duration(days: i));
    //Checks to see if this date is one of the user's chosen days off.
    if (daysOff.contains(DateTime.utc(date.year, date.month, date.day))) {
    } else {
      studyDays.add(StudyDay(
          DateTime.utc(date.year, date.month, date.day, startTime.hour,
              startTime.minute),
          DateTime.utc(
              date.year, date.month, date.day, endTime.hour, endTime.minute)));
    }
  }

  return studyDays;
}

//Takes a number of user generated parameters and generates a study plan for the user.
List<StudyPeriod> generateStudyPlan(StudyPlanParameters studyPlanParameters) {
  List<Subject> subjects = studyPlanParameters.subjects;

  List<StudyPeriod> studyPeriods = [];

  List subjectsWithTimes = [];

  //Creates a map of subject and time, allowing the total time alloted to each subject to be tracked. This allows the algorithm to ensure each subject gets a roughly equal amount of time dedicated to it across the study plan.
  for (Subject subject in subjects) {
    var subjectWithTime = {};
    subjectWithTime['subject'] = subject;
    subjectWithTime['time'] = 0;
    subjectsWithTimes.add(subjectWithTime);
  }

  for (StudyDay studyDay in studyPlanParameters.studyDays) {
    //Works out how much study time is available for a given day.
    int durationInMinutes = ((studyDay.endTime.millisecondsSinceEpoch -
            studyDay.startTime.millisecondsSinceEpoch) ~/
        60000);

    //Works out how many sessions of the user's preferred length can be made, adding them to a list of integers that represent the sessions.
    int noOfStandardSessions =
        durationInMinutes ~/ studyPlanParameters.preferredSessionLength;
    List<int> sessions = [];
    for (var i = 0; i <= noOfStandardSessions; i++) {
      if (i < noOfStandardSessions) {
        sessions.add(studyPlanParameters.preferredSessionLength);
      } else if (i == noOfStandardSessions) {
        sessions.add(
            durationInMinutes % studyPlanParameters.preferredSessionLength);
      }
    }

    //Works out the remaining time after the max number of preferred length sessions are created and added to the list. This remaining time is added as the final session.
    int timeRemaining =
        durationInMinutes % studyPlanParameters.preferredSessionLength;

    if (timeRemaining != 0) {
      sessions.add(timeRemaining);
    }

    for (var i = 0; i < (sessions.length - 1); i++) {
      if (subjectsWithTimes.length > i) {
        studyPeriods.add(StudyPeriod(
            // using start time in MS since epoch for ID
            '',
            (getEndTime(studyDay.startTime, sessions, i)
                    .subtract(Duration(minutes: sessions[i])))
                .millisecondsSinceEpoch,
            (getEndTime(studyDay.startTime, sessions, i))
                .millisecondsSinceEpoch,
            subjectsWithTimes[i]["subject"].id,
            0));
        subjectsWithTimes[i]["time"] += sessions[i];
      } else {
        studyPeriods.add(StudyPeriod(
            // using start time in MS since epoch for ID
            '',
            (getEndTime(studyDay.startTime, sessions, i)
                    .subtract(Duration(minutes: sessions[i])))
                .millisecondsSinceEpoch,
            (getEndTime(studyDay.startTime, sessions, i))
                .millisecondsSinceEpoch,
            subjectsWithTimes[i % subjectsWithTimes.length]["subject"].id,
            0));
        subjectsWithTimes[i % subjectsWithTimes.length]["time"] += sessions[i];
      }
    }

    //At the end of each iteration, the subjects are sorted by how much time has been alotted to each. This means that for the next day, they will be alotted time first, which ensures that they are all given equal amounts of time.
    subjectsWithTimes.sort((a, b) {
      var r = a['time'].compareTo(b['time']);
      if (r != 0) return r;
      return a['time'].compareTo(b['time']);
    });
  }

  return studyPeriods;
}

//Works out when the session will end.
DateTime getEndTime(DateTime startTime, List<int> sessions, int index) {
  int endTimeLag = 0;
  for (var i = 0; i <= index; i++) {
    endTimeLag += sessions[i];
  }
  DateTime newEndTime = startTime.add(Duration(minutes: endTimeLag));
  return newEndTime;
}

//Finds a subject in the database from its ID.
Future<Subject> getSubjectFromID(String id) async {
  List<Subject> subjects = await getSubjectsFB();
  Subject mySubject = Subject(id: '0', name: '');

  for (Subject subject in subjects) {
    if (subject.id == id) {
      mySubject = subject;
    }
  }

  return mySubject;
}

//Checks to see if a study plan already exists.
Future<bool> doesStudyPlanExist() async {
  List<dynamic> studyPlan = await getStudyPlan();
  bool exists = false;

  if (studyPlan.isNotEmpty) {
    exists = true;
  }

  return exists;
}

//Converts a NonStorableStudyPeriod object to a Task object. This basically just allowed me to reuse UI elements from the To-Do page to be reused in the Study Planner page as it was convenient.
Task studyPeriodToTask(NonStorableStudyPeriod studyPeriod) {
  Task task = Task(
      id: studyPeriod.id,
      name: 'Study',
      subject: studyPeriod.subject.name,
      details: 'Start Time: ' +
          timeFormatter(studyPeriod.startTime) +
          '\nEnd Time: ' +
          timeFormatter(studyPeriod.endTime),
      dueDate: studyPeriod.endTime.millisecondsSinceEpoch,
      timeSpent: studyPeriod.timeSpent);
  return task;
}

bool sameDate(DateTime dateOne, DateTime dateTwo) {
  bool result = false;
  if (dateOne.year == dateTwo.year &&
      dateOne.month == dateTwo.month &&
      dateOne.day == dateTwo.day) {
    result = true;
  }
  return result;
}

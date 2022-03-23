/*
This is mostly just the code that was used when the app used an SQL database. 
I decided that data persistance across devices was useful enough that account 
functionality and a Realtime Database would be a better solution. 
As a result a local database is no longer used.
*/






// import 'dart:async';

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:test_project/new_design/Design%20Elements/small_elements.dart';

// import 'firebase_services.dart';

// // class Subject {
// //   final int id;
// //   final String name;

// //   Subject({
// //     required this.id,
// //     required this.name,
// //   });

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'name': name,
// //     };
// //   }

// //   // Implement toString to make it easier to see information about
// //   // each dog when using the print statement.
// //   @override
// //   String toString() {
// //     return 'Subject{id: $id, name: $name}';
// //   }
// // }

// void initialiseSubjectDB() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'subjects.db');

//   openDatabase(path, version: 1, onCreate: (Database db, int version) async {
//     await db
//         .execute('CREATE TABLE Subjects(id INTEGER PRIMARY KEY, name TEXT)');
//   });
// }

// // Future<String> addSubjectData(Subject subject) async {
// //   var databasesPath = await getDatabasesPath();
// //   String path = join(databasesPath, 'subjects.db');

// //   String confirmAdded = 'not added';

// //   List<Subject> subjects = await getSubjectsFB();

// //   for (var i = 0; i < subjects.length; i++) {
// //     if (subjects[i].name == subject.name) {
// //       confirmAdded = 'duplicate';
// //     }
// //   }

// //   if (confirmAdded != 'duplicate') {
// //     Database database = await openDatabase(path);
// //     database.insert('Subjects', subject.toMap(),
// //         conflictAlgorithm: ConflictAlgorithm.replace);

// //     subjects = await getSubjectsFB();
// //     for (var i = 0; i < subjects.length; i++) {
// //       if (subjects[i].id == subject.id) {
// //         confirmAdded = 'added';
// //       }
// //     }
// //   }
// //   return confirmAdded;
// // }

// deleteSubjectData(Subject subject) async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'subjects.db');
//   Database db = await openDatabase(path, version: 1);

//   List<Task> tasks = await getTasks();
//   for (Task task in tasks) {
//     if (task.subject == subject.name) {
//       db.rawDelete('DELETE FROM Tasks WHERE id = ${task.id}');
//     }
//   }

//   return db.rawDelete('DELETE FROM Subjects WHERE id = ${subject.id}');

//   // openDatabase(path, version: 1, onCreate: (Database db, int version) async {
//   //   await db.delete('Subjects', where: 'id = ?', whereArgs: [subject.id]);
//   // });
// }

// // Future<List<Subject>> getSubjects() async {
// //   var databasesPath = await getDatabasesPath();
// //   String path = join(databasesPath, 'subjects.db');

// //   Database database = await openDatabase(path);

// //   final List<Map<String, dynamic>> maps = await database.query('Subjects');

// //   // Convert the List<Map<String, dynamic> into a List<Dog>.
// //   return List.generate(maps.length, (i) {
// //     return Subject(
// //       id: maps[i]['id'],
// //       name: maps[i]['name'],
// //     );
// //   });
// // }

// // class Task {
// //   final int id;
// //   final String name;
// //   final String subject;
// //   final String details;
// //   final int dueDate;

// //   Task(
// //       {required this.id,
// //       required this.name,
// //       required this.subject,
// //       required this.details,
// //       required this.dueDate});

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'name': name,
// //       'subject': subject,
// //       'details': details,
// //       'dueDate': dueDate,
// //     };
// //   }

// //   // Implement toString to make it easier to see information about
// //   // each dog when using the print statement.
// //   @override
// //   String toString() {
// //     return 'Task{id: $id, name: $name, subject: $subject, details: $details, dueDate: $dueDate}';
// //   }
// // }

// deleteTaskData(Task task) async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'tasks.db');

//   Database db = await openDatabase(path, version: 1);
//   return db.rawDelete('DELETE FROM Tasks WHERE id = ${task.id}');
//   // List<Task> tasks = await getTasks();
//   // for (var i = 0; i < tasks.length; i++) {
//   //   if (tasks[i].id == task.id) {
//   //     returnMessage = 'Failed';
//   //   }
//   // }
//   // return returnMessage;
// }

// void initialiseTaskDB() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'tasks.db');

//   openDatabase(path, version: 1, onCreate: (Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE Tasks(id INTEGER PRIMARY KEY, name TEXT, subject TEXT, details TEXT, dueDate INTEGER)');
//   });
// }

// // Future<String> addTaskData(Task task) async {
// //   var databasesPath = await getDatabasesPath();
// //   String path = join(databasesPath, 'tasks.db');

// //   Task finalTask = task;

// //   String confirmAdded = 'not added';

// //   List<Task> tasks = await getTasks();

// //   for (var i = 0; i < tasks.length; i++) {
// //     if (tasks[i].name == task.name) {
// //       finalTask = Task(
// //           id: tasks[i].id,
// //           name: task.name,
// //           subject: task.subject,
// //           details: task.details,
// //           dueDate: task.dueDate);
// //     }
// //   }

// //   if (confirmAdded != 'duplicate') {
// //     Database database = await openDatabase(path);
// //     database.insert('Tasks', finalTask.toMap(),
// //         conflictAlgorithm: ConflictAlgorithm.replace);

// //     tasks = await getTasks();
// //     for (var i = 0; i < tasks.length; i++) {
// //       if (tasks[i].id == task.id) {
// //         confirmAdded = 'added';
// //       }
// //     }
// //   }

// //   return confirmAdded;
// // }

// // Future<List<Task>> getTasks() async {
// //   var databasesPath = await getDatabasesPath();
// //   String path = join(databasesPath, 'tasks.db');

// //   Database database = await openDatabase(path);

// //   final List<Map<String, dynamic>> maps = await database.query('Tasks');

// //   // Convert the List<Map<String, dynamic> into a List<Dog>.
// //   return List.generate(maps.length, (i) {
// //     return Task(
// //         id: maps[i]['id'],
// //         name: maps[i]['name'],
// //         subject: maps[i]['subject'],
// //         details: maps[i]['details'],
// //         dueDate: maps[i]['dueDate']);
// //   });
// // }

import 'firebase_services.dart';

// class StudyPlanParameters {
//   final List<StudyDay> studyDays;
//   final List<Subject> subjects;
//   final int preferredSessionLength;

//   StudyPlanParameters(
//       this.studyDays, this.subjects, this.preferredSessionLength);
// }

// void initialiseStudyPlanDB() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'study_plan.db');

//   openDatabase(path, version: 1, onCreate: (Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE StudyPeriod(id INTEGER PRIMARY KEY, startTime INTEGER, endTime INTEGER, subjectID INTEGER)');
//   });
// }

// Future<String> addToStudyPlanDB(List<StudyPeriod> studyPeriods) async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'study_plan.db');

//   bool exists = await doesStudyPlanExist();

//   if (exists) {
//     deleteStudyPlan();
//   }

//   String confirmAdded = '';

//   Database database = await openDatabase(path);
//   for (StudyPeriod studyPeriod in studyPeriods) {
//     database.insert('StudyPeriod', studyPeriod.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);

//     List<StudyPeriod> studyPlan = await getStudyPlan();
//     for (var i = 0; i < studyPlan.length; i++) {
//       if (studyPlan[i].id == studyPeriod.id) {
//         confirmAdded = 'added';
//       } else {
//         confirmAdded = 'not added';
//       }
//     }
//   }
//   return confirmAdded;
// }

// void deleteStudyPlan() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'study_plan.db');

//   Database database = await openDatabase(path);
//   database.delete('StudyPeriod');
// }

// Future<List<StudyPeriod>> getStudyPlan() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'study_plan.db');

//   Database database = await openDatabase(path);

//   final List<Map<String, dynamic>> maps = await database.query('StudyPeriod');

//   return List.generate(maps.length, (i) {
//     return StudyPeriod(
//       maps[i]['id'],
//       maps[i]['startTime'],
//       maps[i]['endTime'],
//       maps[i]['subjectID'],
//     );
//   });
// }

// Future<List<NonStorableStudyPeriod>> getNonStorableStudyPlan() async {
//   final List<StudyPeriod> studyPlans = await getStudyPlan();

//   List<NonStorableStudyPeriod> finalList = [];

//   for (StudyPeriod studyPlan in studyPlans) {
//     finalList.add(NonStorableStudyPeriod(
//         studyPlan.id,
//         DateTime.fromMillisecondsSinceEpoch(studyPlan.startTimeInMSSE),
//         DateTime.fromMillisecondsSinceEpoch(studyPlan.endTimeInMSSE),
//         await getSubjectFromID(studyPlan.subjectID)));
//   }

//   return finalList;
// }

// Future<NonStorableStudyPeriod> getNonStorableFromStudyPeriod(
//     StudyPeriod studyPeriod) async {
//   NonStorableStudyPeriod nonStorableStudyPeriod = NonStorableStudyPeriod(
//       studyPeriod.id,
//       DateTime.fromMillisecondsSinceEpoch(studyPeriod.startTimeInMSSE),
//       DateTime.fromMillisecondsSinceEpoch(studyPeriod.endTimeInMSSE),
//       await getSubjectFromID(studyPeriod.subjectID));

//   return nonStorableStudyPeriod;
// }

// class StudyDay {
//   DateTime startTime;
//   DateTime endTime;

//   StudyDay(this.startTime, this.endTime);
// }

// class StudyPeriod {
//   final String id;
//   final int startTimeInMSSE;
//   final int endTimeInMSSE;
//   final String subjectID;

//   StudyPeriod(
//       this.id, this.startTimeInMSSE, this.endTimeInMSSE, this.subjectID);

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'startTime': startTimeInMSSE,
//       'endTime': endTimeInMSSE,
//       'subjectID': subjectID,
//     };
//   }

//   // Implement toString to make it easier to see information about
//   // each dog when using the print statement.
//   @override
//   String toString() {
//     return 'Task{id: $id, startTime: $startTimeInMSSE, endTime: $endTimeInMSSE, subjectID: $subjectID}';
//   }
// }

// class NonStorableStudyPeriod {
//   final String id;
//   final DateTime startTime;
//   final DateTime endTime;
//   final Subject subject;

//   NonStorableStudyPeriod(this.id, this.startTime, this.endTime, this.subject);
// }

// List<StudyDay> generateStudyDays(DateTime startDate, DateTime endDate,
//     List<DateTime> daysOff, DateTime startTime, DateTime endTime) {
//   List<StudyDay> studyDays = [];

//   int totalDays =
//       ((endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch) ~/
//               86400000) +
//           1;
//   // print('Total Days: ' + totalDays.toString());
//   for (var i = 0; i < totalDays; i++) {
//     DateTime date = startDate.add(Duration(days: i));
//     if (daysOff.contains(DateTime.utc(date.year, date.month, date.day))) {
//     } else {
//       studyDays.add(StudyDay(
//           DateTime.utc(date.year, date.month, date.day, startTime.hour,
//               startTime.minute),
//           DateTime.utc(
//               date.year, date.month, date.day, endTime.hour, endTime.minute)));
//     }
//   }

//   return studyDays;
// }

// List<StudyPeriod> generateStudyPlan(StudyPlanParameters studyPlanParameters) {
//   List<Subject> subjects = studyPlanParameters.subjects;

//   List<StudyPeriod> studyPeriods = [];

//   List subjectsWithTimes = [];

//   for (Subject subject in subjects) {
//     var subjectWithTime = {};
//     subjectWithTime['subject'] = subject;
//     subjectWithTime['time'] = 0;
//     subjectsWithTimes.add(subjectWithTime);
//   }

//   for (StudyDay studyDay in studyPlanParameters.studyDays) {
//     int durationInMinutes = ((studyDay.endTime.millisecondsSinceEpoch -
//             studyDay.startTime.millisecondsSinceEpoch) ~/
//         60000);

//     int noOfStandardSessions =
//         durationInMinutes ~/ studyPlanParameters.preferredSessionLength;
//     List<int> sessions = [];
//     for (var i = 0; i <= noOfStandardSessions; i++) {
//       if (i < noOfStandardSessions) {
//         sessions.add(studyPlanParameters.preferredSessionLength);
//       } else if (i == noOfStandardSessions) {
//         sessions.add(
//             durationInMinutes % studyPlanParameters.preferredSessionLength);
//       }
//       // studyPeriods.add(StudyPeriod(studyDay.day, DateTime.fromMillisecondsSinceEpoch(studyDay.startTime.millisecondsSinceEpoch + (studyPlanParameters.preferredSessionLength*i)), DateTime.fromMillisecondsSinceEpoch(studyDay.endTime.millisecondsSinceEpoch - (standardSessions)), subject))
//     }

//     int timeRemaining =
//         durationInMinutes % studyPlanParameters.preferredSessionLength;

//     if (timeRemaining != 0) {
//       sessions.add(timeRemaining);
//     }

//     for (var i = 0; i < (sessions.length - 1); i++) {
//       if (subjectsWithTimes.length > i) {
//         studyPeriods.add(StudyPeriod(
//             // using start time in MS since epoch for ID
//             '',
//             (getEndTime(studyDay.startTime, sessions, i)
//                     .subtract(Duration(minutes: sessions[i])))
//                 .millisecondsSinceEpoch,
//             (getEndTime(studyDay.startTime, sessions, i))
//                 .millisecondsSinceEpoch,
//             subjectsWithTimes[i]["subject"].id));
//         subjectsWithTimes[i]["time"] += sessions[i];
//       } else {
//         studyPeriods.add(StudyPeriod(
//             // using start time in MS since epoch for ID
//             '',
//             (getEndTime(studyDay.startTime, sessions, i)
//                     .subtract(Duration(minutes: sessions[i])))
//                 .millisecondsSinceEpoch,
//             (getEndTime(studyDay.startTime, sessions, i))
//                 .millisecondsSinceEpoch,
//             subjectsWithTimes[i % subjectsWithTimes.length]["subject"].id));
//         subjectsWithTimes[i % subjectsWithTimes.length]["time"] += sessions[i];
//       }
//     }
//     // studyPeriods.add(StudyPeriod(
//     //     studyDay.endTime.subtract(Duration(minutes: sessions.last)),
//     //     studyDay.endTime,
//     //     subjects[sessions.length - 1]));

//     subjectsWithTimes.sort((a, b) {
//       var r = a['time'].compareTo(b['time']);
//       if (r != 0) return r;
//       return a['time'].compareTo(b['time']);
//     });
//   }

//   return studyPeriods;
// }

// DateTime getEndTime(DateTime startTime, List<int> sessions, int index) {
//   int endTimeLag = 0;
//   for (var i = 0; i <= index; i++) {
//     endTimeLag += sessions[i];
//   }
//   DateTime newEndTime = startTime.add(Duration(minutes: endTimeLag));
//   return newEndTime;
// }

// Future<Subject> getSubjectFromID(String id) async {
//   List<Subject> subjects = await getSubjectsFB();
//   Subject mySubject = Subject(id: '0', name: '');

//   for (Subject subject in subjects) {
//     if (subject.id == id) {
//       mySubject = subject;
//     }
//   }

//   return mySubject;
// }

// Future<bool> doesStudyPlanExist() async {
//   List<dynamic> studyPlan = await getStudyPlan();
//   bool exists = false;

//   if (studyPlan.isNotEmpty) {
//     exists = true;
//   }

//   return exists;
// }

// Task studyPeriodToTask(NonStorableStudyPeriod studyPeriod) {
//   Task task = Task(
//       id: studyPeriod.id,
//       name: 'Study',
//       subject: studyPeriod.subject.name,
//       details: 'Start Time: ' +
//           timeFormatter(studyPeriod.startTime) +
//           '\n\nEnd Time: ' +
//           timeFormatter(studyPeriod.endTime),
//       dueDate: studyPeriod.endTime.millisecondsSinceEpoch);
//   return task;
// }

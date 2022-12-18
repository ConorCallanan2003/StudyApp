import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_project/new_design/Design%20Elements/small_elements.dart';
import 'package:test_project/new_design/Pages/Focus%20Timer/big_clock_time_picker_widget.dart';

import '../../../services/firebase_services.dart';
import 'big_clock_time_picker_widget.dart';

class StudyTimerPage extends StatefulWidget {
  StudyTimerPage({Key? key, required this.restartTimer}) : super(key: key);

  ValueNotifier<bool> restartTimer;

  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

int initialTime = 0;

bool breakTimerBool = false;

// String selectedAudio = 'Silence';
Task selectedTask =
    Task(id: '', name: '', subject: '', details: '', dueDate: 0, timeSpent: 0);

String timeFormatter(int timeRemaining) {
  int minutes = (timeRemaining ~/ 60);
  int seconds = (timeRemaining % 60).toInt();
  String formattedSeconds = seconds.toString();
  String formattedMinutes = minutes.toString();
  if (seconds < 10) {
    formattedSeconds = '0' + seconds.toString();
  }
  if (minutes < 10) {
    formattedMinutes = '0' + minutes.toString();
  }
  return formattedMinutes + ':' + formattedSeconds;
}

Map map = {};

// bool playAudio = false;

// ignore: prefer_typing_uninitialized_variables
var timer;

int timerValue = 0;

ValueNotifier<bool> timerActive = ValueNotifier(false);

// void setSelectedAudio(audio) {
//   selectedAudio = audio;
// }

int time = 0;

void setSelectedTime(int newTime) {
  time = newTime;
}

var selectedItem;

void setSelectedTask(dynamic task) {
  selectedItem = task;
  if (task is Task) {
    selectedTask = task;
  } else {
    selectedTask = studyPeriodToTask(task);
  }
  selectedTask = task;
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  double size = 400;
  double twoPI = 2 * pi;

  String? selectedValue;

  ValueNotifier<int> timerLengthSeconds = ValueNotifier<int>(0);
  ValueNotifier<int> backUpTimerLengthSeconds = ValueNotifier<int>(0);

  // AudioPlayer audioPlayer = AudioPlayer();
  // AudioCache musicCache = AudioCache();

  // void playLooped() async {
  //   if (audioFileLocations.contains(map[selectedAudio]) &&
  //       (map[selectedAudio] != '') &&
  //       (selectedAudio != 'Silence')) {
  //     playAudio = true;
  //     audioPlayer = await musicCache.loop('audio_files/' + map[selectedAudio]);
  //   } else {
  //     playAudio = false;
  //     // audioPlayer = await musicCache.loop('audio_files/' + audioFileLocations[0]);
  //     selectedAudio = 'Silence';
  //   }
  // }

  // void pauseUnPauseSound() {
  //   if (audioPlayer.state == PlayerState.PLAYING) {
  //     audioPlayer.dispose();
  //   } else if (playAudio) {
  //     playLooped();
  //   }
  // }

  void myTimerTime() {
    print('started');
    initialTime = time * 60;
    timerLengthSeconds.value = time * 60;
    startTimer();
  }

  void pauseUnPauseTimer() {
    // pauseUnPauseSound();
    if (timerActive.value) {
      breakTimerBool = true;
      timerActive.value = false;
    } else {
      breakTimerBool = false;
      timerActive.value = true;
    }
  }

  int timeSpentTracker = 0;

  void startTimer() {
    timerActive.value = true;
    // playLooped();
    // ignore: prefer_const_constructors, unused_local_variable
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if ((timerLengthSeconds.value * 60) == 0) {
        // audioPlayer.stop();
        timer.cancel();
      } else {
        if (timerActive.value) {
          if (timeSpentTracker % 60 == 0 && timeSpentTracker != 0) {
            if (selectedItem is Task) {
              updateTaskData(Task(
                  id: selectedItem.id,
                  name: selectedItem.name,
                  subject: selectedItem.subject,
                  details: selectedItem.details,
                  dueDate: selectedItem.dueDate,
                  timeSpent:
                      (selectedItem.timeSpent + (timeSpentTracker ~/ 60))));
            } else if (selectedItem is NonStorableStudyPeriod) {
              updateStudyPeriodData(NonStorableStudyPeriod(
                  selectedItem.id,
                  selectedItem.startTime,
                  selectedItem.endTime,
                  selectedItem.subject,
                  (selectedItem.timeSpent + (timeSpentTracker ~/ 60))));
            }
          }
          timeSpentTracker += 1;
          timerLengthSeconds.value--;
        }
      }
    });
  }

  void startBreakTimer() {
    if (breakTimerBool) {
      // ignore: prefer_const_constructors, unused_local_variable
      Timer _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (breakTimerBool) {
          backUpTimerLengthSeconds.value++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (width > height) {
      size = height * .8;
    } else {
      size = width * .8;
    }
    // for (var i = 0; i < audioNames.length; i++) {
    //   map[audioNames[i]] = audioFileLocations[i];
    // }
    // double height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
        valueListenable: timerActive,
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              (timerActive.value || timerLengthSeconds.value == 0)
                  ? const Color.fromARGB(255, 217, 244, 255)
                  : Color.fromARGB(206, 215, 36, 23),
              (timerActive.value || timerLengthSeconds.value == 0)
                  ? const Color.fromARGB(255, 177, 226, 247)
                  : Color.fromARGB(255, 174, 71, 63)
            ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 0),
                  child: Text(
                    'Focus Timer',
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                timerLengthSeconds.value == 0
                    ? const SizedBox(height: 0, width: 0)
                    : timerActive.value
                        ? const Text(
                            'Studying',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w200),
                          )
                        : ValueListenableBuilder(
                            valueListenable: backUpTimerLengthSeconds,
                            builder: (context, value, child) {
                              return Text(
                                'On a break: ' +
                                    timeFormatter(
                                        backUpTimerLengthSeconds.value),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200),
                              );
                            }),
                timerLengthSeconds.value == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: SizedBox(
                            width: width,
                            height: 46,
                            child: const TaskSelector()),
                      )
                    : SizedBox(
                        width: width,
                        height: 40,
                        child: Center(
                          child: Text(
                            'Focus: ' +
                                selectedTask.subject +
                                ' ' +
                                selectedTask.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                        )),
                // timerLengthSeconds.value == 0
                //     ? Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 6),
                //         child: SizedBox(
                //             width: width,
                //             height: 46,
                //             child: AudioSelector(
                //               audioNames: audioNames,
                //             )),
                //       )
                //     : SizedBox(
                //         width: width,
                //         height: 40,
                //         child: Center(
                //           child: Text(
                //             'Sound: ' + selectedAudio,
                //             style: const TextStyle(
                //                 fontSize: 22, color: Colors.black87),
                //           ),
                //         )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: ValueListenableBuilder(
                        valueListenable: timerLengthSeconds,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Builder(builder: (context) {
                            while (timerLengthSeconds.value == 0) {
                              if (timerLengthSeconds.value == 0) {
                                return BigClockTimePicker(
                                  widthHeight: size,
                                  active: timerActive.value,
                                  myTimerTime: () {
                                    myTimerTime();
                                  },
                                );
                              }
                            }
                            if (timerLengthSeconds.value != 0) {
                              return GestureDetector(
                                onTap: () {
                                  pauseUnPauseTimer();
                                  if (backUpTimerLengthSeconds.value == 0) {
                                    startBreakTimer();
                                  }
                                },
                                child: SizedBox(
                                  height: size,
                                  width: size,
                                  child: FutureBuilder(
                                    future: null,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      double percentComplete =
                                          timerLengthSeconds.value /
                                              initialTime;
                                      return SizedBox(
                                        width: size - 10,
                                        height: size - 10,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                width: size - 5,
                                                height: size - 5,
                                                decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.white,
                                                          offset:
                                                              Offset(-4, -4),
                                                          blurRadius: 8,
                                                          spreadRadius: 4),
                                                      BoxShadow(
                                                          color: Colors.white,
                                                          offset: Offset(4, 4),
                                                          blurRadius: 8,
                                                          spreadRadius: 4)
                                                    ],
                                                    color: Color(0xff1e1b2e),
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                            RotatedBox(
                                              quarterTurns: 3,
                                              child: ShaderMask(
                                                shaderCallback: (rect) {
                                                  return SweepGradient(
                                                      startAngle: 0.0,
                                                      endAngle: 2 * pi,
                                                      stops: [
                                                        1 - percentComplete,
                                                        1 - percentComplete
                                                      ],
                                                      // 0.0 , 0.5 , 0.5 , 1.0
                                                      center: Alignment.center,
                                                      colors: [
                                                        Colors.blue,
                                                        Colors.white
                                                            .withOpacity(.9),
                                                      ]).createShader(rect);
                                                },
                                                child: Center(
                                                  child: Container(
                                                    width: size - 5,
                                                    height: size - 5,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: size - 20,
                                                height: size - 20,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: Center(
                                                    child: SizedBox(
                                                  height: size / 7,
                                                  width: size / 4,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
                                                        timeFormatter(value),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox(
                                height: 0,
                                width: 0,
                              );
                            }
                          });
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    // audioPlayer.dispose();
    super.dispose();
  }
}

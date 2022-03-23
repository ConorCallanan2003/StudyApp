import 'package:flutter/material.dart';
import 'package:test_project/new_design/Pages/Focus%20Timer/study_timer_page.dart';

class BigClockTimePicker extends StatefulWidget {
  const BigClockTimePicker(
      {Key? key,
      required this.active,
      required this.widthHeight,
      required this.myTimerTime})
      : super(key: key);

  final bool active;
  final double widthHeight;
  final VoidCallback myTimerTime;

  @override
  State<BigClockTimePicker> createState() => _BigClockTimePickerState();
}

class _BigClockTimePickerState extends State<BigClockTimePicker>
    with TickerProviderStateMixin {
  // late Animation<double> animation =
  //     CurvedAnimation(parent: controller, curve: Curves.bounceIn);
  late Animation animation;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1, curve: Curves.easeOutQuart)))
      ..addListener(() {
        setState(() {});
      });
    // animation = Tween<double>(begin: 0, end: 1).animate(controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  int timerTime = 0;

  List<int> times = [15, 30, 45, 60];

  List<Color> colors = [Colors.blue, Colors.blue, Colors.blue, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.widthHeight * 1,
        height: widget.widthHeight * 1,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Center(
            //   child: SizedBox(
            //     height: 400,
            //     width: 400,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                timerTime = times[0];
                colors = [Colors.blue, Colors.blue, Colors.blue, Colors.blue];
                setState(() {
                  colors[0] = Colors.blueGrey;
                });
              },
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                      0 +
                          (((130 / 400) * widget.widthHeight) * animation.value)
                              .toDouble(),
                      0),
                  child: Container(
                    child: Center(
                      child: Text(
                        times[0].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 28),
                      ),
                    ),
                    height: 70,
                    width: 70,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: colors[0]),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                timerTime = times[1];
                colors = [Colors.blue, Colors.blue, Colors.blue, Colors.blue];
                setState(() {
                  colors[1] = Colors.blueGrey;
                });
              },
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                      0,
                      0 +
                          (((130 / 400) * widget.widthHeight) * animation.value)
                              .toDouble()),
                  child: Container(
                    child: Center(
                      child: Text(
                        times[1].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 28),
                      ),
                    ),
                    height: 70,
                    width: 70,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: colors[1]),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                timerTime = times[2];
                colors = [Colors.blue, Colors.blue, Colors.blue, Colors.blue];
                setState(() {
                  colors[2] = Colors.blueGrey;
                });
              },
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                      0 -
                          (((130 / 400) * widget.widthHeight) * animation.value)
                              .toDouble(),
                      0),
                  child: Center(
                    child: Container(
                      child: Center(
                        child: Text(
                          times[2].toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 28),
                        ),
                      ),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: colors[2]),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                timerTime = times[3];
                colors = [Colors.blue, Colors.blue, Colors.blue, Colors.blue];
                setState(() {
                  colors[3] = Colors.blueGrey;
                });
              },
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                      0,
                      0 -
                          (((130 / 400) * widget.widthHeight) * animation.value)
                              .toDouble()),
                  child: Container(
                    child: Center(
                      child: Text(
                        times[3].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 28),
                      ),
                    ),
                    height: 70,
                    width: 70,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: colors[3]),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (controller.isCompleted && timerTime != 0) {
                  setSelectedTime(timerTime);
                  widget.myTimerTime();
                } else if (controller.isCompleted && timerTime == 0) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
              child: Center(
                child: Container(
                  child: Center(
                      child: animation.isCompleted
                          ? timerTime == 0
                              ? Text('Cancel',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(.8 *
                                          ((1 - (2 * animation.value)).abs()))))
                              : Text('Go',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(.8 *
                                          ((1 - (2 * animation.value)).abs()))))
                          : Text('Start',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(
                                      .8 * (1 - animation.value))))),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: const Offset(0, 0),
                            blurRadius: animation.value * 5,
                            spreadRadius: animation.value * 2.5),
                        BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0, 0),
                            blurRadius: (1 - animation.value) * 2.5,
                            spreadRadius: (1 - animation.value) * 2.5)
                      ],
                      border: Border.all(
                          color: Colors.black,
                          width: .1 * (1 - animation.value),
                          style: BorderStyle.solid),
                      shape: BoxShape.circle,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

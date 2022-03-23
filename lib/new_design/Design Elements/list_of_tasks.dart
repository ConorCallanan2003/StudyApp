import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/new_design/Design%20Elements/small_elements.dart';
import 'package:test_project/new_design/Design%20Elements/task_item.dart';

import '../../services/firebase_services.dart';

class ListOfTasks extends StatefulWidget {
  const ListOfTasks(
      {Key? key,
      required this.subject,
      // required this.blurBackground,
      required this.animationController})
      : super(key: key);

  final String subject;
  // final VoidCallback blurBackground;
  final AnimationController animationController;

  @override
  State<ListOfTasks> createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .6475,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: getToDoList(),
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            int index = 0;
            List<Widget> taskSlivers = [];
            List<Widget> studySlivers = [];
            if (snapshot.hasData) {
              for (var i = 0; i < snapshot.data[0].length; i++) {
                if (((snapshot.data[0][i].subject == widget.subject ||
                            widget.subject == 'All') &&
                        !snapshot.data[0][i].completed) ||
                    (widget.subject == 'completed' &&
                        snapshot.data[0][i].completed)) {
                  taskSlivers.add(TaskItem(
                    width: MediaQuery.of(context).size.width,
                    task: snapshot.data[0][i],
                    index: index,
                    listLength:
                        (snapshot.data[0].length + snapshot.data[1].length),
                    scrollController: scrollController,
                    animationController: widget.animationController,
                    // toggleBlurBackground: () => widget.blurBackground(),
                  ));
                  index++;
                } else {}
              }
              if (snapshot.data[1] != null) {
                for (var i = 0; i < snapshot.data[1].length; i++) {
                  studySlivers.add(StudyItem(
                      width: MediaQuery.of(context).size.width,
                      studyPeriod: snapshot.data[1][i]));
                }
              }
              Widget studyBanner() {
                Widget result;
                if (!(studySlivers.length > 0)) {
                  result = const SizedBox(
                    height: 0,
                    width: 0,
                  );
                } else {
                  print(studySlivers);
                  result = const Center(
                    child: Text(
                      'Study',
                      style: TextStyle(fontSize: 28, color: Colors.black87),
                    ),
                  );
                }
                return result;
              }

              return CustomScrollView(
                  controller: scrollController,
                  slivers: taskSlivers +
                      [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: studyBanner()),
                          ),
                        )
                      ] +
                      studySlivers +
                      [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ]);
            } else {
              return const Text(
                'Add a task!',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              );
            }
          }),
    );
  }
}

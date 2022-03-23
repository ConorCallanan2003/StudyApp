import 'package:flutter/material.dart';
import 'package:test_project/new_design/Design%20Elements/dialogues.dart/confirm_subject_delete_dialogue.dart';

import '../../services/firebase_services.dart';

class SubjectHorizontalScrollItem extends StatefulWidget {
  const SubjectHorizontalScrollItem(
      {Key? key,
      required this.subject,
      required this.index,
      required this.selectedIndex,
      this.completed = false})
      : super(key: key);

  final Subject subject;
  final int index;
  final int selectedIndex;
  final bool completed;

  @override
  State<SubjectHorizontalScrollItem> createState() =>
      _SubjectHorizontalScrollItemState();
}

class _SubjectHorizontalScrollItemState
    extends State<SubjectHorizontalScrollItem> {
  @override
  Widget build(BuildContext context) {
    // ValueNotifier<bool> isAlive = ValueNotifier(true);

    return GestureDetector(
        onLongPress: () {
          confirmSubjectDelete(context, widget.subject);
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black26,
                        style: BorderStyle.solid,
                        width: .2),
                    color: widget.selectedIndex == widget.index
                        ? Colors.white
                        : widget.completed
                            ? Colors.blueGrey
                            : Color.fromARGB(194, 224, 241, 254),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Center(
                  child: Text(
                    widget.subject.name,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  ),
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:test_project/services/firebase_services.dart';

Future<void> addSubjectDialogue(BuildContext context) async {
  final subjectNameController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text('Add New Subject'),
        content: SizedBox(
          height: 40,
          width: 180,
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: 'Subject Name', border: InputBorder.none),
            controller: subjectNameController,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.tealAccent),
            ),
            onPressed: () async {
              await addSubjectDataFB(
                  Subject(id: '', name: subjectNameController.text));
              // addSubjectData(Subject(
              //   id: Random().nextInt(1000000),
              //   name: subjectNameController.text,
              // ));

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

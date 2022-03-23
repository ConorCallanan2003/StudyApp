import 'package:flutter/material.dart';

import '../../../services/firebase_services.dart';

Future<void> confirmSubjectDelete(BuildContext context, Subject subject) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text('Are you sure?'),
        content: Text(
          'This will result in ${subject.name} being permanently deleted, along with all associated tasks.',
          style: const TextStyle(fontSize: 16),
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
              'Confirm',
              style: TextStyle(color: Colors.tealAccent),
            ),
            onPressed: () async {
              await deleteSubjectDataFB(subject);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

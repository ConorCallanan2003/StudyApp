import 'package:flutter/material.dart';

import '../../../services/firebase_services.dart';

Future<void> confirmTaskDelete(BuildContext c, Task task) async {
  return showDialog<void>(
    context: c,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text('Are you sure?'),
        content: Text(
          'This will result in \'${task.name}\' being permanently deleted.',
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
              deleteTaskData(task);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

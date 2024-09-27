import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Wash'),
        content: Text('Are you sure you have picked up all these clothes?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false); // Dismiss dialog with false
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true); // Dismiss dialog with true
            },
          ),
        ],
      );
    },
  );
}

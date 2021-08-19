import 'package:flutter/material.dart';

// DataInputAlert class object for easier formatting of a AlertDialog
class DataInputAlert {
  DataInputAlert({
    @required this.onPressed,
    @required this.alertMessage,
    @required this.alertTitle,
  });
  final onPressed;
  final alertTitle;
  final alertMessage;

  AlertDialog showAlert() {
    return AlertDialog(
      title: Text(alertTitle),
      content: Text(alertMessage),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: onPressed,
        )
      ],
    );
  }
}

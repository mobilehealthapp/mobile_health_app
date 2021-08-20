import 'package:flutter/material.dart';
import 'settings_constants.dart';

class Alert extends StatelessWidget {
  // used when user first presses on the delete my data/account button(s) (first alert to show up)
  Alert({required this.alertBody, required this.widget});

  final String
  alertBody; // tell user what this alert entails based on what they press on
  final Widget
  widget; // define where the user should be directed to next (delete data or delete account?)

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Are you sure?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      content: Text(
        alertBody,
        // define in file depending on which delete tab the user selects
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'), // exit alert
          child: Text(
            'Cancel',
            style: kAlertTextStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return widget; // move to next alert where they input credentials to complete action
              },
            );
          },
          child: Text(
            'Confirm',
            style: kAlertTextStyle,
          ),
        ),
      ],
    );
  }
}

class Alert2 extends StatelessWidget {
  // used when user asks 'what is this?' on doctor's access code section in add a doctor
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'When signing up, your physician was assigned a 16-character code that is unique to them. Please contact your physician for this code if you have not yet received it.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Okay'),
          child: Text(
            'Okay',
            style: kAlertTextStyle,
          ),
        ),
      ],
    );
  }
}

class Alert3 extends StatelessWidget {
  // used when user asks 'what is this?' on the doctor's label section in add a doctor
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'This label is to help you remember your doctor\'s specialization. You can specify if they are your family physician, a specialist, or whichever label you would like!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Okay'),
          child: Text(
            'Okay',
            style: kAlertTextStyle,
          ),
        ),
      ],
    );
  }
}
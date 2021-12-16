import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

class PatientNotifications extends StatefulWidget {
  @override
  _PatientNotificationsState createState() => _PatientNotificationsState();
}
//TODO: Give the patient the option to select when their notification is scheduled for and connect to Notifications.dart

class _PatientNotificationsState extends State<PatientNotifications> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SwitchListTile(
            title: const Text('Turn on Daily Reminders'),
            value: _isSelected,
            onChanged: (bool newValue) {
              setState(() {
                _isSelected = newValue;
              });
            },
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

class DrNotifications extends StatefulWidget {
  @override
  _DrNotificationsState createState() => _DrNotificationsState();
}

//TODO: Connect the notification settings on this page with the Notifications.dart file

class _DrNotificationsState extends State<DrNotifications> {
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
            title: const Text('Show Notifications'),
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

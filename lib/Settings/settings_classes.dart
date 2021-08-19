import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alerts.dart';

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); // create this as global variable

class TabContent extends StatelessWidget {
  // used on buttons which show a chevron > meaning it will navigate to another page
  TabContent({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        Text(
          label,
          style: kLabelStyle,
        ),
        Icon(
          CupertinoIcons.chevron_forward,
          color: Colors.white,
        ),
      ],
    );
  }
}

class TabContent2 extends StatelessWidget {
  // used on delete my data/account buttons as they don't need a chevron (to go to another page)
  TabContent2({required this.label});

  final String
      label; // label to tell user what will happen when pressing this button

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        Text(
          label,
          style: kLabelStyle,
        ),
      ],
    );
  }
}

class SettingsButton extends StatelessWidget {
  // used as buttons on settings pages to take users to other pages
  SettingsButton({required this.route, required this.label});

  final String
      route; // defines where user will go (use named routes from main.dart file)
  final String label; // label to tell user where button will take them

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: TabContent(
          label: label,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(route);
        },
        style: kSettingsCardStyle,
      ),
    );
  }
}

class RedSettingsButton extends StatelessWidget {
  // used as buttons on settings pages to take users to alerts to delete data/account

  RedSettingsButton(
      {required this.label, required this.alertBody, required this.widget});

  final String label;
  final String
      alertBody; // tell user what this alert entails based on what they press on
  final Widget
      widget; // define where the user should be directed to next (delete data or delete account?)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: TabContent2(
          label: label,
        ),
        style: kRedButtonStyle,
        onPressed: () async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return new Alert(
                widget: widget,
                alertBody: alertBody,
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  // used as card to display user's profile information
  ProfileTab({required this.editAnswer});

  final String editAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100.0,
      ),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          editAnswer,
          style: kLabelStyle,
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  // used to press confirm on an alert
  final String label;
  final VoidCallback
      onPressed; // define what happens when user presses 'confirm'

  ConfirmButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
      onPressed: onPressed,
      child: Text(
        label,
        style: kAlertTextStyle,
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  // used to press cancel on a delete alert
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
      onPressed: () => Navigator.of(context)..pop()..pop(),
      child: Text(
        'Cancel',
        style: kAlertTextStyle,
      ),
    );
  }
}

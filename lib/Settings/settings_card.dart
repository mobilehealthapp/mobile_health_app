import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();
bool checkCurrentPasswordValid = true;

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); // create this as global variable

var sex;

getUserData(uid) async {
  final DocumentSnapshot patientInfo =
  await patientRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
      sex = patientInfo.get('sex');
}

class SettingsCard extends StatelessWidget {
  // used as buttons that can take user to another page
  SettingsCard({required this.settingsTab});

  final Widget settingsTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: settingsTab,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

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
      ],
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
      constraints: BoxConstraints(minHeight: 100.0,),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          editAnswer,
          style: GoogleFonts.rubik(
            textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

class Alert extends StatelessWidget {
  // used when user first presses on the delete my data/account button(s) (first alert to show up)
  Alert({required this.alertBody, required this.widget});

  final String alertBody;
  final Widget widget;

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
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
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
                return widget;
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

class CancelOrConfirm extends StatelessWidget {
  // used when editing information; can either be a button which cancels or confirms changes
  CancelOrConfirm({required this.whichOne, required this.colour});

  final String whichOne;
  final dynamic colour;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colour,
      ),
      height: 40.0,
      child: Center(
        child: Text(
          whichOne,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}

class Alert3 extends StatelessWidget {
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

class Alert4 extends StatelessWidget {
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

class ConfirmButton extends StatelessWidget {
  // used to press confirm on an alert
  final String label;
  final VoidCallback onPressed;

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
  // used to press cancel on an alert
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
      onPressed: () =>
      Navigator.of(context)
        ..pop()..pop(),
      child: Text(
        'Cancel',
        style: kAlertTextStyle,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_constants.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();
bool checkCurrentPasswordValid = true;

class SettingsCard extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'When signing up, your physician was assigned a 12-digit code that is unique to them. Please contact your physician for this code if you have not yet received it.',
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

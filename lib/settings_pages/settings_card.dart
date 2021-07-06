import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kLabelStyle = GoogleFonts.rubik(
  textStyle: TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  ),
);

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
          height: 10.0,
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

class RedCard extends StatelessWidget {
  RedCard({required this.deleteTab});

  final Widget deleteTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: deleteTab,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.red[900],
        borderRadius: BorderRadius.circular(10.0),
      ),
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
          height: 10.0,
        ),
        Text(
          label,
          style: kLabelStyle,
        ),
      ],
    );
  }
}

class CustomField extends StatelessWidget {
  CustomField({required this.hintLabel, required this.onSubmitted});

  final String hintLabel;
  final Function onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        hintText: hintLabel,
        hintStyle: GoogleFonts.rubik(
          textStyle: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      onChanged: (null),
      onSubmitted: onSubmitted(),
    );
  }
}

class ProfileTab extends StatelessWidget {
  ProfileTab({required this.editAnswer});

  final String editAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
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

class ContactTab extends StatelessWidget {
  ContactTab({required this.answer});

  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        color: Color(0xFF757575),
      ),
      child: Center(
        child: Text(
          answer,
          style: GoogleFonts.rubik(
            textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ContactEditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          'Edit',
          style: GoogleFonts.rubik(
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.red[900],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

final kFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.all(10.0),
  hintStyle: GoogleFonts.rubik(
    textStyle: TextStyle(
      fontSize: 20.0,
      color: Colors.black,
    ),
  ),
);

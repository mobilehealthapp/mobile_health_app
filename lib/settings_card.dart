import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const labelStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
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
          style: labelStyle,
        ),
        Icon(CupertinoIcons.chevron_forward),
      ],
    );
  }
}

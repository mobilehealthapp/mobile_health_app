import 'package:flutter/material.dart';
import 'settings_card.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'My Profile'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Country/Region'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Privacy Policy'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Terms and Conditions'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Medical Disclaimer'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Container(
                child: Center(
                  child: Text(
                    'Delete My Data',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(
                  35.0,
                  10.0,
                  35.0,
                  10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

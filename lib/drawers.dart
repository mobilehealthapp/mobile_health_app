import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/HomePage.dart';
import 'package:mobile_health_app/physHome.dart';

import 'health_analysis.dart';
import 'package:mobile_health_app/buttontest.dart';
import 'package:mobile_health_app/health_analysis.dart';
import 'package:mobile_health_app/settings_pages/settings.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';

class Drawers extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 100),
              SizedBox(height: 10),
              addItem(
                text: 'Home',
                icon: Icons.home,
                onClicked: () => select(context, 0),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Settings',
                icon: Icons.settings,
                onClicked: () => select(context, 1),
              ),

              SizedBox(height: 10),
              addItem(
                text: 'Health Analysis',
                icon: Icons.health_and_safety,
                onClicked: () => select(context, 2),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Contact',
                icon: Icons.contacts,
                onClicked: () => select(context, 5),
              ),

              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Physician Side ',
                icon: Icons.logout,
                onClicked: () => select(context, 5),
              ),
              // SizedBox
            ],
          ),
        ),
      ),
    );
  }

  Widget addItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }

  select(BuildContext context, int i) {
    Navigator.of(context).pop();
    switch (i) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HealthAnalysis()));
        break;
      case 3:
        Navigator.of(context).pushNamed('/healthAnalysis');
        break;
      case 4:
        Navigator.of(context).pushNamed('/physHome');
        break;
      case 5:
        Navigator.of(context).pushNamed('/physHome');
        break;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/HomePage.dart';
import 'package:mobile_health_app/physHome.dart';
import 'package:mobile_health_app/settings_pages/settings.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';
import 'health_analysis.dart';

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
              addItem(
                text: 'Settings',
                icon: Icons.settings,
                onClicked: () => select(context, 1),
              ),
              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  _auth.signOut();
                  Navigator.of(context).push(
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HealthAnalysis()));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HealthAnalysis()));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PhysHome()));
        break;
      case 5:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PhysHome()));
        break;
    }
  }
}

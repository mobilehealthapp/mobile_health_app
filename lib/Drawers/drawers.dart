import 'package:flutter/material.dart';

class Drawers extends StatelessWidget {

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
                text: 'Health Analysis Form',
                icon: Icons.health_and_safety,
                onClicked: () => select(context, 3),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Settings',
                icon: Icons.settings,
                onClicked: () => select(context, 1),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () => select(context, 4),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Physician Side ',
                icon: Icons.logout,
                onClicked: () => select(context, 5),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'ML ',
                icon: Icons.add_chart,
                onClicked: () => select(context, 6),
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
        Navigator.of(context).pushNamed('/home'); // navigate to the patient home page
        break;
      case 1:
        Navigator.of(context).pushNamed('/settings'); // navigate to the patient settings page
        break;
      case 2:
        Navigator.of(context).pushNamed('/healthAnalysis'); // navigate to the health analysis page
        break;
      case 3:
        Navigator.of(context).pushNamed('/healthAnalysisForm'); // navigate to the health analysis form
        break;
      case 4:
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false); // navigate to the welcome page (logout)
        break;
      case 5:
        Navigator.of(context).pushNamed('/physHome'); // ONLY FOR EASE OF NAVIGATION! PLEASE TAKE OUT OF FINAL PRODUCT
        break;
      case 6:
        Navigator.of(context).pushNamed('/ml'); // ONLY FOR EASE OF NAVIGATION! PLEASE TAKE OUT OF FINAL PRODUCT
        break;

    }
  }
}

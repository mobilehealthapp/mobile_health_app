import 'package:flutter/material.dart';
import 'package:mobile_health_app/Profile.dart';
import 'package:mobile_health_app/physHome.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';

class PhysDrawers extends StatelessWidget {
  const PhysDrawers({Key? key}) : super(key: key);
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
                text: 'PhysHome',
                icon: Icons.home,
                onClicked: () => select(context, 0),
              ),
              addItem(
                text: 'My Patients',
                icon: Icons.perm_identity,
                onClicked: () => select(context, 1),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Setting',
                icon: Icons.settings,
                onClicked: () => select(context, 2),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Health Analysis',
                icon: Icons.health_and_safety,
                onClicked: () => select(context, 3),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'More Information',
                icon: Icons.info,
                onClicked: () => select(context, 4),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Contact Patient',
                icon: Icons.contacts,
                onClicked: () => select(context, 5),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Logout ',
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
            .push(MaterialPageRoute(builder: (context) => PhysHome()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PhysHome()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PhysHome()));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PhysHome()));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
        break;
    }
  }
}

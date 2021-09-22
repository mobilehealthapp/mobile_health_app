import 'package:flutter/material.dart';

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
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () => select(context, 2),
              ),
              SizedBox(height: 10),
              addItem(
                text: 'Patient Side',
                icon: Icons.logout,
                onClicked: () => select(context, 3),
              ),
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
        Navigator.of(context).pushNamed('/physHome'); // navigate to the physician home page
        break;
      case 1:
        Navigator.of(context).pushNamed('/drSettings'); // navigate to the physician settings page
        break;
      case 2:
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false); // navigate to the welcome page (logout)
        break;
      case 3:
        Navigator.of(context).pushNamed('/home'); // ONLY FOR EASE OF NAVIGATION! PLEASE TAKE OUT OF FINAL PRODUCT
        break;
    }
  }
}

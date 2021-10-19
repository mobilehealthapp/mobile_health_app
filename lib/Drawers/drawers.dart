import 'package:flutter/material.dart';
import 'package:mobile_health_app/Home_Page/logout.dart';

class DrawerEntry {
  ///A [DrawerEntry] object is a quick way to define all the info needed to
  ///make an entry to the list of drawers.
  ///
  /// An entry in the sidebar will visually show [icon] next to [name].
  ///
  /// When tapped, [path] will be pushed with pushNamed onto the navigator,
  /// if [removeUntilEmpty] (default false) is set to true, pushNamedAndRemoveUntil
  /// will be used instead. This is included as 'logout' uses it.

  String name; //The name to be displayed on the entry in the Drawer menu
  IconData icon; //The icon to be displayed on the entry in the Drawer menu
  String path; //The Path that will be pushed onto the navigator
  bool removeUntilEmpty; //default false. Set true to clear routes before pushed

  DrawerEntry(this.name, this.path, this.icon, {this.removeUntilEmpty = false});

  void push(BuildContext context) => Navigator.of(context).pushNamed(path);

  ListTile addListTile(BuildContext context) {
    ///Make a ListTile to display in Drawers.
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () => push(context)
    );
  }
}

class LogoutEntry extends DrawerEntry {
  ///Extends DrawerEntry. Logout removes everything from the stack
  ///so you can't just hit back to go back in, it also logs out of Firebase.
  LogoutEntry():super('logout', '/', Icons.logout);

  @override
  void push(BuildContext context) async => LogoutButton.logout(context);

}

class Drawers extends StatelessWidget {
  ///Drawers creates a Drawer from a list of [DrawerEntry]'s, that when tapped push
  ///a path to the navigator. Meant for patients! PhysicianDrawers is defined below.
  ///
  ///To add a new drawer entry for patients, add a [DrawerEntry] to [drawerEntries],
  ///Create a new DrawerEntry and specify the [name], [path], and [icon].
  ///The entry's will appear in the sidebar in the order they are in the list.
  ///
  ///Hint!! Don't forget to specify where your path points.
  ///Do that in the routes map in main.dart

  final List<DrawerEntry> drawerEntries = [
    DrawerEntry('Home', '/home', Icons.home),
    DrawerEntry('Settings', '/settings', Icons.settings),
    DrawerEntry('Health Analysis', '/healthAnalysis', Icons.health_and_safety),
    DrawerEntry(
        'Health Analysis Form', '/healthAnalysisForm', Icons.health_and_safety),
    LogoutEntry(),
    DrawerEntry('Physician Side', '/physHome', Icons.logout),
    DrawerEntry('ML', '/ml', Icons.add_chart),
    DrawerEntry('Predictions', '/PredictiveGraph', Icons.add_chart),
  ];

  ListView generateListView(BuildContext context) {
    List<Widget> returnList = [SizedBox(height: 100)];
    for (DrawerEntry entry in drawerEntries) {
      returnList.add(SizedBox(height: 10));
      returnList.add(entry.addListTile(context));
    }
    return ListView(children: returnList);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: generateListView(context),
        ),
      ),
    );
  }
}


class PhysicianDrawers extends Drawers{
  ///Drawers creates a Drawer from a list of [DrawerEntry]'s, that when tapped push
  ///a path to the navigator. Meant for physicians! Drawers is defined above.
  ///
  ///To add a new drawer entry for patients, add a [DrawerEntry] to [drawerEntries],
  ///Create a new DrawerEntry and specify the [name], [path], and [icon].
  ///The entry's will appear in the sidebar in the order they are in the list.
  ///
  ///Hint!! Don't forget to specify where your path points.
  ///Do that in the routes map in main.dart
  final List<DrawerEntry> drawerEntries = [
    DrawerEntry('PhysHome', '/physHome', Icons.home),
    DrawerEntry('My Patients', '/physHome', Icons.perm_identity),
    DrawerEntry('Settings', '/drSettings', Icons.settings),
    LogoutEntry(),
    DrawerEntry('Patient Side', '/home', Icons.logout),
    DrawerEntry('ML', '/ml', Icons.add_chart),
    DrawerEntry('Predictions', '/PredictiveGraph', Icons.add_chart),
  ];
}

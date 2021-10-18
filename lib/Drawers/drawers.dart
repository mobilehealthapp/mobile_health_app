import 'package:flutter/material.dart';

class DrawerEntry {
  ///A [DrawerEntry] object is a quick way to define all the info needed to
  ///make an entry to the list of drawers.
  ///
  /// An entry in the sidebar will visually show [icon] next to [name].
  ///
  /// When tapped, [path] will be pushed with pushNamed onto the navigator,
  /// [removeUntilEmpty] (default false) is set to true, pushNamedAndRemoveUntil
  /// will be used instead. This is included as 'logout' uses it.

  String name; //The name to be displayed on the entry in the Drawer menu
  IconData icon; //The icon to be displayed on the entry in the Drawer menu
  String path; //The Path that will be pushed onto the navigator
  bool removeUntilEmpty; //default false. Set true to clear routes before pushed

  DrawerEntry(this.name, this.path, this.icon, {this.removeUntilEmpty = false});

  ListTile addListTile(BuildContext context) {
    ///Make a ListTile to display in Drawers.
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () => this.removeUntilEmpty
          ? Navigator.of(context).pushNamed(path)
          : //Normally, path is pushed to navigator
      Navigator.of(context).pushNamedAndRemoveUntil(
          path, //Removes all routes below pushed route
              (Route<dynamic> route) => false),
    );
  }
}

class Drawers extends StatelessWidget {
  ///Drawers creates a ListView of [DrawerEntry]'s, that when tapped push
  ///a path to the navigator.
  ///To add a new drawer entry, add a [DrawerEntry] to [drawerEntries],
  ///specifying the [name], [path], and [icon].
  ///The entry's will appear in the sidebar in the order they are in the list.
  ///
  ///Hint!! Don't forget to specify where your path points.
  ///Do that in the routes map in main.dart

  final List<DrawerEntry> drawerEntries = [
    DrawerEntry('Home', '/home', Icons.home),
    DrawerEntry('Settings', '/settings', Icons.settings),
    DrawerEntry('Health Analysis', '/healthAnalysis', Icons.health_and_safety),
    DrawerEntry('Health Analysis Form', '/healthAnalysisForm', Icons.health_and_safety),
    DrawerEntry('Logout', '/', Icons.logout, removeUntilEmpty:true),
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

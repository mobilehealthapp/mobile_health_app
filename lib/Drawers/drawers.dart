import 'package:flutter/material.dart';
import 'drawer_entries.dart';

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
    //DrawerEntry('Predictions', '/PredictiveGraph', Icons.add_chart), dont wan't patients seeing predicted data
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
    DrawerEntry('Patient Predictions', '/PatientSelect', Icons.add_chart),
  ];
}

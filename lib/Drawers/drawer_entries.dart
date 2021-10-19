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
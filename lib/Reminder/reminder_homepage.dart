import 'package:flutter/material.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'calendar_widget.dart';
import 'event_editing_page.dart';

//This is the first page that opens from the drawer icon called reminders
//A calendar is displayed with the option to add a new event when the button is pressed
class ReminderHompage extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
        drawer: Drawers(),
        appBar: AppBar(
          title: Text("Your Reminders"),
          centerTitle: true,
        ),
        body: CalendarWidget(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.blue,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EventEditingPage()),
          ),
        ),
      );
}

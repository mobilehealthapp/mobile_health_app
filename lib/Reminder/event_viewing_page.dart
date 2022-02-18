import './event_model.dart';
import './event_editing_page.dart';
import './event_provider.dart';
import './utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  //This builds the UI for displaying the event details
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingActions(context, event),
        ),
        body: ListView(
          padding: EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            SizedBox(height: 32),
            Text(
              event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              event.description,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );

  //This displays the time and if it's all day then it shows as all day
  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

  //Formatting of the date
  Widget buildDate(String title, DateTime date) {
    final styleTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final styleDate = TextStyle(fontSize: 18);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: styleTitle)),
          Text(Utils.toDateTime(date), style: styleDate),
        ],
      ),
    );
  }

  //If the user clicks the "x" button it goes back, if they click the edit, it sends them to the edit page
  //If the user clicks delete, it calls the delete function from the event provider widget
  List<Widget> buildViewingActions(BuildContext context, Event event) => [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);

            provider.deleteEvent(event);
            Navigator.of(context).pop();
          },
        ),
      ];
}

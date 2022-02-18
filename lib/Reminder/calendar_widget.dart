import './event_data_source.dart';
import './event_provider.dart';
import './tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Here the widget is accessing the list of events
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      view: CalendarView.month,
      //This widget created in here will allow the SfCalendar to understand the events list
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onSelectionChanged: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
      },
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        if (provider.selectedDate == details.date) {
          showModalBottomSheet(
            context: context,
            builder: (context) => TasksWidget(),
          );
        }
      },

      //When on the reminder home screen, long pressing a date will pop up the task widget to show the reminders for the given day
      onLongPress: (details) {
        //This saves the reference to the date that is pressed by the user
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
        //This will then set the date selected to show the pop up of all the events
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(),
        );
      },
    );
  }
}

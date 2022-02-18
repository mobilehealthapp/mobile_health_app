import './event_data_source.dart';
import './event_viewing_page.dart';
import './event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'event_data_source.dart';
import 'event_provider.dart';
import 'event_viewing_page.dart';

class TasksWidget extends StatefulWidget {
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    //First you get the evet providers reference to which date is clicked
    final provider = Provider.of<EventProvider>(context);
    //This grabs references to all the events for a particular date
    final selectedEvents = provider.eventsOfSelectedDate;

    //If there aren't any events for a particular date then show the text
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No Events found!',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }

    //Here a calendar is returned in the modal from the
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      child: SfCalendar(
        //This shows the calendar in the timeline view
        view: CalendarView.timelineDay,
        //Put all the events in here from the particular date
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        //This widget is key to being able to hold the event details which the onTap will use
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.transparent,
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        onTap: (details) {
          if (details.appointments == null) return;

          final event = details.appointments!.first;

          //If not null, then this can pass the events details to the viewing page to get details of the event
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventViewingPage(event: event),
          ));
        },
      ),
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    //Get the appointment details
    final event = details.appointments.first;

    //This just shows the UI for the events in a particular date with their respective times
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

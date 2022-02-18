import './event_model.dart';
import "package:flutter/material.dart";
import "package:syncfusion_flutter_calendar/calendar.dart";

//Here you put the events inside the appointments field
class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  //The calenderdatasource needs to be overriden here to add the events properties
  //It also allows it to interpret the data structure we are using
  //It allows the mapping the custom values from, to, title, etc to the calendardatasource

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}

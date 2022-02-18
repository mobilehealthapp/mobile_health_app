import 'package:flutter/material.dart';

//In the event editing page, there is a stateful widget that has the Event object
//This is the inner workings of the object, it has the constructor and the fields
class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.blueGrey,
    this.isAllDay = false,
  });
}

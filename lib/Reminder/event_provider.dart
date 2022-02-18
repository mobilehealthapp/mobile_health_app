import './event_model.dart';
import './utils.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  //This will store the list of events, some of them are listed below as examples
  final List<Event> _events = [
    Event(
      title: 'Learn about thyroid cancer',
      description: 'Watch YouTube Videos',
      from: DateTime.now(),
      to: DateTime.now().add(Duration(hours: 2)),
    ),
    Event(
      title: 'Meeting With Doctor',
      description: 'Meeting for medication treatment',
      from: DateTime.now().subtract(Duration(hours: 6)),
      to: DateTime.now().add(Duration(hours: 4)),
    )
  ];

  //This creates a border around the date clicked on the calendar hompage
  DateTime _selectedDate = DateTime.now();

  //This getter and setter method is for the selected date
  DateTime get selectedDate => _selectedDate;
  void setDate(DateTime date) => _selectedDate = date;

  //This will calculate all of the events of a specific date
  //It will also only show the events of this particular date not other dates
  List<Event> get eventsOfSelectedDate => _events.where(
        (event) {
          final selected = Utils.removeTime(_selectedDate);
          final from = Utils.removeTime(event.from);
          final to = Utils.removeTime(event.to);

          return from.isAtSameMomentAs(selectedDate) ||
              to.isAtSameMomentAs(selectedDate) ||
              (selected.isAfter(from) && selected.isBefore(to));
        },
      ).toList();

  List<Event> get events => _events;

  //This function will add the event object to the list of events
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  //This function will delete an event object from the list of events
  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  //This will allow for focusing in of an event to edit
  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }
}

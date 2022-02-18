import './event_model.dart';
import './event_provider.dart';
import './utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//This is the main editing page for a reminder

class EventEditingPage extends StatefulWidget {
  //This event object holds all of the data from the users entry
  final Event? event;

  //This is the constructor for the event
  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  //variables involved in the creation of a reminder
  final _formKey = GlobalKey<FormState>();
  //The title and description controllers allow for the tracking of text state
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool isAllDay = false;

  //This will set the default values for the from and to dates
  @override
  void initState() {
    super.initState();

    //This is triggered when the user is creating an event
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
    //Otherwise set it to the persons liking if they are editing their event and not creating
    else {
      final event = widget.event!;

      titleController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
      isAllDay = event.isAllDay;
    }
  }

  //Get rid of the title and description controllers after done using them
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  //This is the UI component that will render the event editing page
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildEditingActions(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitle(),
                SizedBox(height: 12),
                buildDateTimePickers(),
                SizedBox(height: 12),
                buildDescription(),
              ],
            ),
          ),
        ),
      );

  //This widget creates the save button to save the form
  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: Icon(Icons.done),
          label: Text('SAVE'),
        ),
      ];

  //This widget builds the title textbox
  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  //This widget builds the description field for the user
  Widget buildDescription() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Add Details',
        ),
        textInputAction: TextInputAction.newline,
        maxLines: 5,
        onFieldSubmitted: (_) => saveForm(),
        controller: descriptionController,
      );

  //This widget will build the logic behind the all day events in case they are clicked
  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          if (!isAllDay) buildTo(),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('All Day Event'),
            value: isAllDay,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) => setState(() => isAllDay = value!),
          )
        ],
      );

  //This widget will build the from date and time logic
  Widget buildFrom() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                //This Utils will format the date field
                text: Utils.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            if (!isAllDay)
              //If the event isn't all day then the second drop down to pick a time should display
              Expanded(
                child: buildDropdownField(
                  //This one will format the time
                  text: Utils.toTime(fromDate),
                  onClicked: () => pickFromDateTime(pickDate: false),
                ),
              ),
          ],
        ),
      );

  //This widget will build the to date and time logic
  Widget buildTo() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  //This widget is used to build the headers for the from and to date
  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
            child,
          ],
        ),
      );

  //This creates the drop down that, when clicked in the from or to pickers is triggered
  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      //This creates the tile to display the date
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        //When the drop down is clicked the calendar triggers
        onTap: onClicked,
      );

  //This is triggered when the from date/time is clicked on
  Future pickFromDateTime({required bool pickDate}) async {
    //This takes the fromDate object and the boolean pickDate to ensure we don't mix up the date/time
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    //If the user backs out without selecting a date then it won't throw an exception
    if (date == null) return;

    //If the from date picked is before the default to date, then make the to date the same as the from date
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }

  //This is just as the pickFromDateTime but for the to date time
  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      //set the first date pickable for the to date to the same day as the from date
      firstDate: pickDate ? fromDate : null,
    );
    //If the user backs out an exception won't be thrown
    if (date == null) return;

    setState(() => toDate = date);
  }

  //This widget combines the date and time into an object
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      //If the pickDate is true then we need to have these parameters ready
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      //In case the user does pick a date, this stores and adds the time to the date to return back to where it was called
      //The reason the time is saved here is so that only the date can be changed
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    }
    //If we aren't picking a date then we are picking a time
    else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      //Here we want to hold the reference to the date so that we only edit the time
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  //This widget contains the logic to save the form from the users entries and applies some logic
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    //If the form is valid then create an event object passing all the parameters
    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: isAllDay ? fromDate : toDate,
        isAllDay: isAllDay,
      );

      //This boolean will allow dart to know whether the user is editing an event or has just created a new event
      final isEditing = widget.event != null;
      //This provider will allow for the event to be added to the calendar
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        //This will allow the user to edit their event
        provider.editEvent(event, widget.event!);

        Navigator.of(context).pop();
      }
      //This allows for adding an event
      else {
        provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }
}

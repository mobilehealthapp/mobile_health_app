import 'package:flutter/material.dart';

class DateTimePickerIcon extends StatefulWidget {
  @override
  _DateTimePickerIconState createState() => _DateTimePickerIconState();
}

class _DateTimePickerIconState extends State<DateTimePickerIcon> {
  late DateTime pickedDate;
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a date"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[],
        ),
      ),
    );
  }
}

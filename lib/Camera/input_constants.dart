import 'package:flutter/material.dart';

// Constant for the data types
const List dataTypes = [
  'Select Data Type',
  'Blood Pressure',
  'Blood Glucose',
  'Heart Rate',
];

// Constant for number of variables required for each data type
const List kNumberOfVariables = [
  ['Blood Pressure', 2],
  ['Blood Glucose', 1],
  ['Heart Rate', 1],
];

// Text style for dropdown menu
const TextStyle kDropdownTextStyle =
    TextStyle(fontSize: 20.0, color: Colors.black);

// Variables for inputted data
double? systolicInput;
double? diastolicInput;
double? glucoseLevelInput;
String? glucoseUnit;
double? bpmInput;

//////// Constants for Text fields for each data type ////////

// Blood Pressure text fields
Column bloodPressureTF = Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Systolic (SYS)',
          style: kDropdownTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter measurement',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value != '') {
                  systolicInput = double.parse(value);
                } else {
                  systolicInput = null;
                }
              },
            ),
          ),
        ),
        Text(
          'mmHg',
          style: kDropdownTextStyle,
        )
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Diastolic (DIA)',
          style: kDropdownTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter measurement',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value != '') {
                  diastolicInput = double.parse(value);
                } else {
                  diastolicInput = null;
                }
              },
            ),
          ),
        ),
        Text(
          'mmHg',
          style: kDropdownTextStyle,
        )
      ],
    ),
  ],
);

// Blood Glucose text fields
String? bloodGlucoseUnit = 'Select unit type';

class BloodGlucoseTF extends StatefulWidget {
  @override
  _BloodGlucoseTFState createState() => _BloodGlucoseTFState();
}

class _BloodGlucoseTFState extends State<BloodGlucoseTF> {
  @override
  void initState() {
    bloodGlucoseUnit = 'Select unit type';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter measurement',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  if (value != '') {
                    glucoseLevelInput = double.parse(value);
                  } else {
                    glucoseLevelInput = null;
                  }
                });
              },
            ),
          ),
        ),
        DropdownButton(
            value: bloodGlucoseUnit,
            items: [
              DropdownMenuItem(
                child: Text('Select unit type'),
                value: 'Select unit type',
              ),
              DropdownMenuItem(
                child: Text('mmol/L'),
                value: 'mmol/L',
              ),
              DropdownMenuItem(
                child: Text('mg/dL'),
                value: 'mg/dL',
              ),
            ],
            onChanged: (String? value) {
              if (value != 'Select unit type') {
                glucoseUnit = value;
              } else {
                glucoseUnit = null;
              }
              setState(() {
                bloodGlucoseUnit = value;
              });
            }),
      ],
    );
  }
}

// Heart Rate text fields
Row heartRateTF = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Heart Rate',
      style: kDropdownTextStyle,
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Enter measurement',
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value != '') {
              bpmInput = double.parse(value);
            } else {
              bpmInput = null;
            }
          },
        ),
      ),
    ),
    Text(
      'bpm',
      style: kDropdownTextStyle,
    )
  ],
);

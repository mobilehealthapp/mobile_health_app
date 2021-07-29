import 'package:flutter/material.dart';

const kPrimaryColour = Color(0xFF1B4DA8);
const kSecondaryColour = Color(0xFFDAE9F4);

const List dataTypes = [
  'Select Data Type',
  'Blood Pressure',
  'Blood Glucose',
  'Heart Rate',
];

const List kNumberOfVariables = [
  ['Blood Pressure', 2],
  ['Blood Glucose', 1],
  ['Heart Rate', 1],
];

double? systolic;
double? diastolic;
double? glucoseLevel;
String? glucoseUnit;
double? bpm;

Column bloodPressureTF = Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Systolic (SYS)',
          style: kTextStyle,
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
                  systolic = double.parse(value);
                } else {
                  systolic = null;
                }
              },
            ),
          ),
        ),
        Text(
          'mmHg',
          style: kTextStyle,
        )
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Diastolic (DIA)',
          style: kTextStyle,
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
                  diastolic = double.parse(value);
                } else {
                  diastolic = null;
                }
              },
            ),
          ),
        ),
        Text(
          'mmHg',
          style: kTextStyle,
        )
      ],
    ),
  ],
);

String? bloodGlucoseUnit = 'Select unit type';

class BloodGlucoseTF extends StatefulWidget {
  @override
  _BloodGlucoseTFState createState() => _BloodGlucoseTFState();
}

class _BloodGlucoseTFState extends State<BloodGlucoseTF> {
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
                    glucoseLevel = double.parse(value);
                  } else {
                    glucoseLevel = null;
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

Row heartRateTF = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Heart Rate',
      style: kTextStyle,
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
              bpm = double.parse(value);
            } else {
              bpm = null;
            }
          },
        ),
      ),
    ),
    Text(
      'bpm',
      style: kTextStyle,
    )
  ],
);

const TextStyle kTextStyle = TextStyle(fontSize: 20.0, color: Colors.black);

import 'package:flutter/material.dart';

const List dataTypes = [
  'Select Data Type',
  'Blood Pressure',
  'Blood Glucose',
  'Heart Rate',
];

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
                print(value);
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
                print(value);
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

Row bloodGlucoseTF = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Blood Glucose',
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
            print(value);
          },
        ),
      ),
    ),
    Text(
      'mmol/L',
      style: kTextStyle,
    )
  ],
);

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
            print(value);
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

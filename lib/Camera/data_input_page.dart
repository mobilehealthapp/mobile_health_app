import 'package:flutter/material.dart';
import 'input_constants.dart';
import 'package:flutter/cupertino.dart';
import 'camera_input.dart';
import 'data_input_alert.dart';

class DataInput extends StatefulWidget {
  @override
  _DataInputState createState() => _DataInputState();
}

class _DataInputState extends State<DataInput> {
  bool first = true;

  String? selectedDataType = dataTypes[0];

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String dataType in dataTypes) {
      var newItem = DropdownMenuItem(
        child: Text(
          dataType,
          style: kTextStyle,
        ),
        value: dataType,
      );
      dropdownItems.add(newItem);
    }

    // Dropdown menu to select a data type
    // once a type is selected, the corresponding text fields will appear
    return DropdownButton<String>(
      value: selectedDataType,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          systolic = null;
          diastolic = null;
          glucoseLevel = null;
          glucoseUnit = null;
          bpm = null;
          selectedDataType = value;
          if (selectedDataType == 'Blood Pressure') {
            textFields = bloodPressureTF;
          } else if (selectedDataType == 'Blood Glucose') {
            textFields = BloodGlucoseTF();
          } else if (selectedDataType == 'Heart Rate') {
            textFields = heartRateTF;
          } else {
            textFields = Container();
          }
        });
      },
    );
  }

  Widget textFields = Container();

  @override
  Widget build(BuildContext context) {
    // The below gesture detector dismisses any keyboard when the user
    // taps anywhere on the page
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Record your measurement'),
          backgroundColor: Colors.cyan,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Data type:',
                style: kTextStyle,
              ),
              SizedBox(
                width: 15.0,
              ),
              androidDropdown(),
            ]),
            textFields,
            // Elevated button below: the submit button for this page
            // when pressed, the app redirects to the camera page (see camera_input.dart)
            // the app will only redirect if and only if there is a valid input
            // the in put is valid if:
            //      - a data type is selected
            //      - values are specified for the chosen data type
            //      - a unit is chosen if the data type = Blood Glucose
            // if the input is not valid, a corresponding alert will pop up
            ElevatedButton(
                onPressed: () async {
                  print(selectedDataType);
                  print(systolic);
                  print(diastolic);
                  // first check: BP chosen AND systolic empty AND diastolic empty
                  if (selectedDataType == 'Blood Pressure' &&
                      systolic == null &&
                      diastolic == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataInputAlert(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  alertMessage:
                                      'Please input values for your blood pressure',
                                  alertTitle: 'Missing Blood Pressure Data')
                              .showAlert();
                        });
                  }
                  // check: BP chosen AND (systolic empty OR diastolic empty)
                  else if (selectedDataType == 'Blood Pressure' &&
                      (systolic == null || diastolic == null)) {
                    String type = (systolic == null ? 'systolic' : 'diastolic');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataInputAlert(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  alertMessage:
                                      'Please input a value for your $type blood pressure',
                                  alertTitle:
                                      'Missing ${type[0].toUpperCase()}${type.substring(1)} Blood Pressure')
                              .showAlert();
                        });
                  }
                  // check: BG chosen AND glucose level empty AND glucose unit empty
                  else if (selectedDataType == 'Blood Glucose' &&
                      glucoseLevel == null &&
                      glucoseUnit == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataInputAlert(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  alertMessage:
                                      'Please input values for your blood glucose',
                                  alertTitle: 'Missing Blood Glucose data')
                              .showAlert();
                        });
                  }
                  // check: BG chosen AND (glucose level empty OR glucose unit empty)
                  else if (selectedDataType == 'Blood Glucose' &&
                      (glucoseLevel == null || glucoseUnit == null)) {
                    String msg = (glucoseLevel == null
                        ? 'input a value for your blood glucose level'
                        : 'select a measurement unit');
                    String title = (glucoseLevel == null
                        ? 'Blood Glucose Level'
                        : 'Blood Glucose Unit');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataInputAlert(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  alertMessage: 'Please $msg',
                                  alertTitle:
                                      'Missing ${title[0].toUpperCase()}${title.substring(1)}')
                              .showAlert();
                        });
                  }
                  // check: BPM chosen AND bpm empty
                  else if (selectedDataType == 'Heart Rate' && bpm == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataInputAlert(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  alertMessage: 'Please input your heart rate',
                                  alertTitle: 'Missing Heart Rate Data')
                              .showAlert();
                        });
                  }
                  // check: no data type was chosen
                  else if (selectedDataType == 'Select Data Type') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataInputAlert(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  alertMessage: 'Please select a Data Type',
                                  alertTitle: 'Missing Data Type')
                              .showAlert();
                        });
                  }
                  // All clear!
                  else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CameraApp()));
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan)),
                child: Container(
                  child: Text('Submit'),
                ))
          ],
        ),
      ),
    );
  }
}

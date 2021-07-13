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
  String _value = '';
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

    return DropdownButton<String>(
      value: selectedDataType,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          systolic = null;
          diastolic = null;
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
            ElevatedButton(
                onPressed: () async {
                  print(selectedDataType);
                  print(systolic);
                  print(diastolic);
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
                  } else if (selectedDataType == 'Blood Pressure' &&
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
                  } else if (selectedDataType == 'Select Data Type') {
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
                  } else {
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

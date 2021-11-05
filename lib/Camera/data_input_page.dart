import 'package:flutter/material.dart';
import 'input_constants.dart';
import 'package:flutter/cupertino.dart';
import 'data_input_alert.dart';
import '../Data/data_transfer.dart';
import 'package:mobile_health_app/constants.dart';

String dataType = '';
Data inputtedData = Data(null, null, null);

// This is the Data input page where users manually enter their data before
// proceeding to the camera/OCR functionality part of the app
class DataInput extends StatefulWidget {
  @override
  _DataInputState createState() => _DataInputState();
}

class _DataInputState extends State<DataInput> {
  bool first = true;

  String? selectedDataType = dataTypes[0];

  // Dropdown menu for the data type selection
  DropdownButton<String> dropdownMenu() {
    // Below is the list of data types formatted as DropdownMenuItems
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String dataType in dataTypes) {
      var newItem = DropdownMenuItem(
        child: Text(
          dataType,
          style: kDropdownTextStyle,
        ),
        value: dataType,
      );
      dropdownItems.add(newItem);
    }
    // Dropdown menu to select a data type
    // Once a type is selected, the corresponding text fields will appear
    return DropdownButton<String>(
      value: selectedDataType,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          systolicInput = null;
          diastolicInput = null;
          glucoseLevelInput = null;
          glucoseUnit = null;
          bpmInput = null;
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
  void initState() {
    inputtedData = Data(null, null, null);
    super.initState();
  }

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
        backgroundColor: kSecondaryColour,
        appBar: AppBar(
          title: Text('Record your measurement'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Data type:',
                style: kDropdownTextStyle,
              ),
              SizedBox(
                width: 15.0,
              ),
              dropdownMenu(),
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
                  // first check: BP chosen AND systolic empty AND diastolic empty
                  if (selectedDataType == 'Blood Pressure' &&
                      systolicInput == null &&
                      diastolicInput == null) {
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
                      (systolicInput == null || diastolicInput == null)) {
                    String type =
                        (systolicInput == null ? 'systolic' : 'diastolic');
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
                      glucoseLevelInput == null &&
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
                      (glucoseLevelInput == null || glucoseUnit == null)) {
                    String msg = (glucoseLevelInput == null
                        ? 'input a value for your blood glucose level'
                        : 'select a measurement unit');
                    String title = (glucoseLevelInput == null
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
                  else if (selectedDataType == 'Heart Rate' &&
                      bpmInput == null) {
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
                    dataType = selectedDataType!;
                    var data1;
                    var data2;
                    if (dataType == "Blood Pressure") {
                      data1 = systolicInput;
                      data2 = diastolicInput;
                    } else if (dataType == "Blood Glucose") {
                      data1 = glucoseLevelInput;
                      data2 = glucoseUnit;
                    } else {
                      data1 = bpmInput;
                    }
                    inputtedData = Data(dataType, data1, data2);
                    Navigator.of(context).pushNamed('/cameraInput');
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColour)),
                child: Container(
                  child: Text('Submit'),
                ))
          ],
        ),
      ),
    );
  }
}

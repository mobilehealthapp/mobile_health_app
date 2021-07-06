import 'package:flutter/material.dart';
import 'input_constants.dart';
import 'package:flutter/cupertino.dart';

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
          selectedDataType = value;
          if (selectedDataType == 'Blood Pressure') {
            textFields = bloodPressureTF;
          } else if (selectedDataType == 'Blood Glucose') {
            textFields = bloodGlucoseTF;
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
      child: MaterialApp(
        home: Scaffold(
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'analysis_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var patientData = FirebaseFirestore.instance
    .collection('patientData')
    .doc(FirebaseAuth.instance.currentUser!.uid);
var bloodGlucose = patientData.collection('bloodGlucose');
var bloodPressure = patientData.collection('bloodPressure');
var heartRate = patientData.collection('heartRate');
List bg = [];
List hr = [];
List sys = [];
List dia = [];

// This page is primarily used as a proof of concept and thus requires more work
// it essentially allows the user to fill out their information and receive
// a summary comparing their data to what would be considered ideal for their
// demographic

// General constants used on the page
TextStyle kTempTextStyle = TextStyle(color: Colors.white);
Color kActiveRadioColour = Colors.cyan;
bool warning = false;
String warningText = '';

class HealthAnalysisForm extends StatefulWidget {
  const HealthAnalysisForm({Key? key}) : super(key: key);

  @override
  _HealthAnalysisFormState createState() => _HealthAnalysisFormState();
}

class _HealthAnalysisFormState extends State<HealthAnalysisForm> {
  String? _diabetic;
  String? _sex;
  int? _age;
  String resultsMessage = '';
  bool calculate = false;
  String warningMessage = '';

  bgGet() async {
    bg = [];
    final bgData = await bloodGlucose.get();
    final value = bgData.docs;
    for (var val in value) {
      double bgGet = val.get('blood glucose (mmol|L)');
      bg.add(bgGet.toDouble());
    }
    return bg;
  }

  hrGet() async {
    hr = [];
    final hrData = await heartRate.get();
    final value = hrData.docs;
    for (var val in value) {
      int hrGet = val.get('heart rate');
      hr.add(hrGet.toDouble());
    }
    return hr;
  }

  sysGet() async {
    sys = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('systolic');
      sys.add(bpGet.toDouble());
    }
    return sys;
  }

  diaGet() async {
    dia = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('diastolic');
      dia.add(bpGet.toDouble());
    }
    return dia;
  }

  @override
  void initState() {
    setState(() {
      warning = false;
      warningMessage = '';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // This allows for the number keyboard to be dismissed if the user
      // taps anywhere on the screen
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: kSecondaryColour,
        drawer: Drawers(),
        appBar: AppBar(
          title: Text('Health Analysis'),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white,
            disabledColor: Colors.white,
          ),
          child: Container(
            child: ListView(
              children: <Widget>[
                // Age card
                ReusableCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 170,
                        child: Text(
                          'Age',
                          style: kTempTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                        width: 170.0,
                        child: TextField(
                          cursorColor: Colors.white,
                          style: kTempTextStyle,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColour, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            hintText: 'Enter your age',
                            hintStyle:
                                kTempTextStyle.copyWith(color: Colors.white60),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _age = int.parse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Biological sex card
                ReusableCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130.0,
                        child: Text(
                          'Biological sex',
                          style: kTempTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 220,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text('Male', style: kTempTextStyle),
                                leading: Radio(
                                  activeColor: kActiveRadioColour,
                                  value: 'Male',
                                  groupValue: _sex,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _sex = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text('Female', style: kTempTextStyle),
                                leading: Radio(
                                  activeColor: kActiveRadioColour,
                                  value: 'Female',
                                  groupValue: _sex,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _sex = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text('Prefer not to say',
                                    style: kTempTextStyle),
                                leading: Radio(
                                  activeColor: kActiveRadioColour,
                                  value: 'Prefer not to say',
                                  groupValue: _sex,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _sex = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Diabetic card
                ReusableCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          'Diabetic?',
                          style: kTempTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 200,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListTile(
                                title:
                                    Text('Yes (Type I)', style: kTempTextStyle),
                                leading: Radio(
                                  activeColor: kActiveRadioColour,
                                  value: 'yes (type I)',
                                  groupValue: _diabetic,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _diabetic = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text('Yes (Type II)',
                                    style: kTempTextStyle),
                                leading: Radio(
                                  activeColor: kActiveRadioColour,
                                  value: 'yes (type II)',
                                  groupValue: _diabetic,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _diabetic = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text('No', style: kTempTextStyle),
                                leading: Radio(
                                  activeColor: kActiveRadioColour,
                                  value: 'No',
                                  groupValue: _diabetic,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _diabetic = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Calculate button
                Center(
                  child: CupertinoButton(
                    child: Text(
                      'Calculate',
                      style: kTempTextStyle,
                    ),
                    color: kPrimaryColour,
                    onPressed: () async {
                      calculate = true;
                      // Calls getIdealBP first then getAverageResults
                      getIdealBP(_age!, _sex!, (_diabetic != 'No'));
                      String results = await getAverageResults(
                          FirebaseAuth.instance.currentUser!.uid.toString());
                      setState(() {
                        // changes the resultsMessage and potentially the warningMessage
                        resultsMessage = results;
                        warningMessage = warningText;
                        warning = warning;
                      });
                    },
                  ),
                ),
                calculate
                    ? ReusableCard(
                        // Summary card
                        color: kPrimaryColour,
                        child: Text(
                          resultsMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ))
                    : Container(), // empty container if there's no summary to show
                warning
                    ? ReusableCard(
                        // Warning card
                        color: Colors.red,
                        child: Column(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              warningMessage,
                              style: kTempTextStyle.copyWith(fontSize: 20),
                            ),
                          ],
                        ))
                    : Container() // empty container if there's no warning to show
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Class used to display the components on the page
class ReusableCard extends StatelessWidget {
  final Widget child;
  final Color? color;

  ReusableCard({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: (color == null) ? Color(0xFF607D8B) : color,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

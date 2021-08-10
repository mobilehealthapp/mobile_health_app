import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'analysis_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                Center(
                  child: CupertinoButton(
                    child: Text(
                      'Calculate',
                      style: kTempTextStyle,
                    ),
                    color: kPrimaryColour,
                    onPressed: () async {
                      calculate = true;
                      getIdealBP(_age!, _sex!, (_diabetic != 'No'));
                      String results = await getAverageResults(
                          FirebaseAuth.instance.currentUser!.uid.toString());
                      setState(() {
                        resultsMessage = results;
                        warningMessage = warningText;
                        warning = warning;
                      });
                    },
                  ),
                ),
                calculate
                    ? ReusableCard(
                        color: kPrimaryColour,
                        child: Text(
                          resultsMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ))
                    : Container(),
                warning
                    ? ReusableCard(
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
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

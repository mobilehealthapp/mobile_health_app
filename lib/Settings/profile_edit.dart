import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Settings/settings_constants.dart';
import 'package:mobile_health_app/Authentication/database_auth_services.dart';

final patientRef = FirebaseFirestore.instance.collection(
    'patientprofile'); // CollectionReference used to access patient's profile data on Firestore
var adr; // home address
var age; // age
var conds; // medical conditions that the patient has
var dob; // date of birth
var first; // first name
var ht; // height
var last; // last name
var meds; // medications that the patient is on
var province; // province or territory
var sex; // sex of patient
var tele; // telephone number
var wt; // weight
var diabetes; // does the patient have diabetes
var tachycardia; // does the patient have tachycardia
var bradycardia; // does the patient have bradycardia
var hypertension; // does the patient have hypertension
var hypotension; // does the patient have hypotension
var cvd; // does the patient have cardiovascular disease
var highHR; // high heart rate threshold
var lowHR;  // low heart rate threshold
var highBG;  // high blood glucose threshold
var lowBG;  // low blood gluscose threshold
var highBP; // high overall blood pressure threshold
var lowBP;  // low overall blood pressure threshold
var highSYS;  // high systolic blood pressure threshold
var lowSYS; // low systolic blood pressure threshold
var highDIA;  // high diastolic blood pressure threshold
var lowDIA; // low diastolic blood pressure threshold
var highHRArray = new List<double>.empty(growable: true); // Used to determine heart rate threshold when there are multiple underlying health conditions
var lowHRArray = new List<double>.empty(growable: true); // Used to determine heart rate threshold when there are multiple underlying health conditions
var highBGArray = new List<double>.empty(growable: true); // Used to determine blood gluscose threshold when there are multiple underlying health conditions
var lowBGArray = new List<double>.empty(growable: true); // Used to determine blood gluscose threshold when there are multiple underlying health conditions
var highSYSArray = new List<double>.empty(growable: true); // Used to determine systolic blood pressure threshold when there are multiple underlying health conditions
var lowSYSArray = new List<double>.empty(growable: true); // Used to determine systolic blood pressure threshold when there are multiple underlying health conditions
var highDIAArray = new List<double>.empty(growable: true); // Used to determine diastolic blood pressure threshold when there are multiple underlying health conditions
var lowDIAArray = new List<double>.empty(growable: true); // Used to determine diastolic blood pressure threshold when there are multiple underlying health conditions
var conditions = new List<String>.empty(growable: true);  // List of medical conditions the patient has selected 'Yes' for


class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var uid;
  bool showSpinner = false;

  TextEditingController adrTEC = TextEditingController();
  TextEditingController ageTEC = TextEditingController();
  TextEditingController condsTEC = TextEditingController();
  TextEditingController dobTEC = TextEditingController();
  TextEditingController firstTEC = TextEditingController();
  TextEditingController htTEC = TextEditingController();
  TextEditingController lastTEC = TextEditingController();
  TextEditingController medsTEC = TextEditingController();
  TextEditingController teleTEC = TextEditingController();
  TextEditingController wtTEC = TextEditingController();
  TextEditingController diabetesTEC = TextEditingController();
  TextEditingController hyperTEC = TextEditingController();
  TextEditingController hypoTEC = TextEditingController();
  TextEditingController tachTEC = TextEditingController();
  TextEditingController bradTEC = TextEditingController();
  TextEditingController cvdTEC = TextEditingController();

void getPatientConditions(){
    conditions.clear();

    // if patient has diabetes add to conditions list
    if (diabetes == 'Yes Type I')
        conditions.add('diabetes');
    else if (diabetes == 'Yes Type II')
        conditions.add('diabetes');
    // if patient has hypertension add to conditions list
    if (hypertension == 'Yes')
        conditions.add('hypertension');
    // if patient has hypotenision add to conditions list
    if (hypotension == 'Yes')
        conditions.add('hypotenision');
    // if patient has tachycardia add to conditions list
    if (tachycardia == 'Yes')
        conditions.add('tachycardia');
    // if patient has bradycardia add to conditions list
    if (bradycardia == 'Yes')
        conditions.add('bradycardia');
    // if patient has cardiovascular disease add to conditions list
    if (cvd == 'Yes')
        conditions.add('cvd');
    }

  /* Medical conditions will take priority in finding the thresholds of each patient.
  If there is more than one medical condition then the high and low values of each
  condition will be found - the highest low value and lowest high value will be
  used as the patient's threshold values.
  If the patient has no underlying health conditions then the patients age & sex 
  (BMI may be added in the future) will be used to determine their threshold levels.
  If the patient has submitted no information, baseline values for a healthy middle-age
  adult will be used as their thresehold value until they update their information in 
  the settings profile. */

  //TO DO: Update Threshold numbers as more acurate information becomes available
  void updateThresholds(){
    var _cond;
    int _age = int.parse(age);
    getPatientConditions();

  // If the patient only has on selected health condition
    if (conditions.length == 1)
    {
      _cond = conditions[0];
      switch(_cond){
          case "diabetes":
              highHR = 100;
              lowHR = 60;
              highBG = 180;
              lowBG = 70;
              highSYS = 130;
              lowSYS = 120;
              highDIA = 80;
              lowDIA = 70;
          break;
          case "hypertension":
              highHR = 93.2;
              lowHR = 72.38;
              highBG = 140;
              lowBG = 70;
              highSYS = 160;
              lowSYS = 135;
              highDIA = 100;
              lowDIA = 85;
          break;
          case "hypotension":
              highHR = 70;
              lowHR = 60;
              highBG = 140;
              lowBG = 70;
              highSYS = 120;
              lowSYS = 90;
              highDIA = 80;
              lowDIA = 60;
          break;
          case "tachycardia":
              highHR = 100;
              lowHR = 80;
              highBG = 140;
              lowBG = 70;
              highSYS = 135;
              lowSYS = 90;
              highDIA = 85;
              lowDIA = 60;
          break;
          case "bradyacrdia":
              highHR = 70;
              lowHR = 55;
              highBG = 140;
              lowBG = 70;
              highSYS = 135;
              lowSYS = 90;
              highDIA = 85;
              lowDIA = 60;
          break;
          case "cvd":
              highHR = 80;
              lowHR = 60;
              highBG = 140;
              lowBG = 70;
              highSYS = 157;
              lowSYS = 147;
              highDIA = 70;
              lowDIA = 60;
          break;
      }
    }
    // If there is more then one selected health condition
    else if (conditions.length > 1){
        for(int i = 0; i < conditions.length; i++){
          _cond = conditions[i];
          switch(_cond){
              case "diabetes":
                  highHRArray.add(100);
                  lowHRArray.add(60);
                  highBGArray.add(180);
                  lowBGArray.add(70);
                  highSYSArray.add(130);
                  lowSYSArray.add(120);
                  highDIAArray.add(80);
                  lowDIAArray.add(70);
              break;
              case "hypertension":
                  highHRArray.add(93.2);
                  lowHRArray.add(72.38);
                  highBGArray.add(140);
                  lowBGArray.add(70);
                  highSYSArray.add(160);
                  lowSYSArray.add(135);
                  highDIAArray.add(100);
                  lowDIAArray.add(85);
              break;
              case "hypotension":
                  highHRArray.add(70);
                  lowHRArray.add(60);
                  highBGArray.add(140);
                  lowBGArray.add(70);
                  highSYSArray.add(120);
                  lowSYSArray.add(90);
                  highDIAArray.add(80);
                  lowDIAArray.add(60);
              break;
              case "tachycardia":
                  highHRArray.add(100);
                  lowHRArray.add(80);
                  highBGArray.add(140);
                  lowBGArray.add(70);
                  highSYSArray.add(135);
                  lowSYSArray.add(90);
                  highDIAArray.add(85);
                  lowDIAArray.add(60);
              break;
              case "bradycardia":
                  highHRArray.add(70);
                  lowHRArray.add(55);
                  highBGArray.add(140);
                  lowBGArray.add(70);
                  highSYSArray.add(135);
                  lowSYSArray.add(90);
                  highDIAArray.add(85);
                  lowDIAArray.add(60);
              break;
              case "cvd":
                  highHRArray.add(80);
                  lowHRArray.add(60);
                  highBGArray.add(140);
                  lowBGArray.add(70);
                  highSYSArray.add(157);
                  lowSYSArray.add(147);
                  highDIAArray.add(70);
                  lowDIAArray.add(60);
              break;
          }
        }
          var _highHR = highHRArray[0];
          var _lowHR = lowHRArray[0];
          var _highBG = highBGArray[0];
          var _lowBG = lowBGArray[0];
          var _highSYS = highSYSArray[0];
          var _lowSYS = lowSYSArray[0];
          var _highDIA = highDIAArray[0];
          var _lowDIA = lowDIAArray[0];

          // find lowest high value
          for(int i = 1; i < highHRArray.length; i++){
              if (_highHR > highHRArray[i])
                _highHR = highHRArray[i];
              if (_highBG > highBGArray[i])
                _highBG = highBGArray[i];
              if (_highSYS > highSYSArray[i])
                _highSYS = highSYSArray[i];
              if (_highDIA > highDIAArray[i])
                _highDIA = highDIAArray[i];
          }
          // find highest low value
          for(int i = 1; i < lowHRArray.length; i++){
              if (_lowHR < lowHRArray[i])
                _lowHR = lowHRArray[i];
              if (_lowBG < lowBGArray[i])
                _lowBG = lowBGArray[i];
              if (_lowSYS > lowSYSArray[i])
                _lowSYS = lowSYSArray[i];
              if (_lowDIA > lowDIAArray[i])
                _lowDIA = lowDIAArray[i];
          }
          highHR = _highHR;
          lowHR = _lowHR;
          highBG = _highBG;
          lowBG = _lowBG;
          highSYS = _highSYS;
          lowSYS = _lowSYS;
          highDIA = _highDIA;
          lowDIA = _lowDIA;
    }
  // If the patient has none of the select health conditions, use age and sex to find their threshold values
  //TO DO: Add BMI as another determining factor of the threshold value
    else if (conditions.length == 0){
      switch (sex){
          case 'M':
              if (17 <= _age && _age <= 25){
                  highHR = 79.4;
                  lowHR = 58.4;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (26 <= _age && _age <= 35){
                  highHR = 78.0;
                  lowHR = 58.8;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (36 <= _age && _age <= 45){
                  highHR = 85.8;
                  lowHR = 59.8;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (46 <= _age && _age <= 55){
                  highHR = 76.9;
                  lowHR = 61.3;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (56 <= _age){
                  highHR = 79.4;
                  lowHR = 60.2;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              break;
          case 'F':
              if (17 <= _age && _age <= 25){
                  highHR = 90.2;                  
                  lowHR = 63.2;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (26 <= _age && _age <= 35){
                  highHR = 84.0;
                  lowHR = 58.6;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (36 <= _age && _age <= 45){
                  highHR = 87.6;
                  lowHR = 65.4;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (46 <= _age && _age <= 55){
                  highHR = 80.6;
                  lowHR = 63.0;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (56 <= _age){
                  highHR = 77.2;
                  lowHR = 58.8;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              break;
          case 'X':
              if (17 <= _age && _age <= 25){
                  highHR = 84.8;                  
                  lowHR = 60.8;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (26 <= _age && _age <= 35){
                  highHR = 81.0;
                  lowHR = 58.7;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (36 <= _age && _age <= 45){
                  highHR = 78.67;
                  lowHR = 62.6;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (46 <= _age && _age <= 55){
                  highHR = 78.75;
                  lowHR = 62.15;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              else if (56 <= _age){
                  highHR = 78.3;
                  lowHR = 59.5;
                  highBG = 140;
                  lowBG = 70;
                  highSYS = 135;
                  lowSYS = 90;
                  highDIA = 85;
                  lowDIA = 60;
              }
              break;
      }
    }
    else {
      highHR = 100;
      lowHR = 60;
      highBG = 1;
      lowBG = 70;
      highSYS = 135;
      lowSYS = 90;
      highDIA = 85;
      lowDIA = 60;
    }

    setState(
      () {
        highHR = highHR.toString();
        lowHR = lowHR.toString();
        highBG = highBG.toString();
        lowBG = lowBG.toString();
        highBP = (highSYS.toString() + '/' + highDIA.toString());
        lowBP = (lowSYS.toString() + '/' + lowDIA.toString());
      },
    );  
  }

  void updateProfile() {
    // this function tells code that if the user does not enter anything
    // in a specific text field, don't change it in Firestore
    setState(
      () {
        if (adrTEC.text == '') {
          adr = adr;
        } else
          adr = adrTEC.text;

        if (ageTEC.text == '') {
          age = age;
        } else
          age = ageTEC.text;

        if (condsTEC.text == '') {
          conds = conds;
        } else
          conds = condsTEC.text;

        if (dobTEC.text == '') {
          dob = dob;
        } else
          dob = dobTEC.text;

        if (firstTEC.text == '') {
          first = first;
        } else
          first = firstTEC.text;

        if (htTEC.text == '') {
          ht = ht;
        } else
          ht = htTEC.text;

        if (lastTEC.text == '') {
          last = last;
        } else
          last = lastTEC.text;

        if (medsTEC.text == '') {
          meds = meds;
        } else
          meds = medsTEC.text;

        if (teleTEC.text == '') {
          tele = tele;
        } else
          tele = teleTEC.text;

        if (wtTEC.text == '') {
          wt = wt;
        } else
          wt = wtTEC.text;

        if (diabetesTEC.text == '') {
          diabetes = diabetes;
        } else
          diabetes = diabetesTEC.text;
          
        if (hyperTEC.text == '') {
          hypertension = hypertension;
        } else
          hypertension = hyperTEC.text;

        if (hypoTEC.text == '') {
          hypotension = hypotension;
        } else
          hypotension = hypoTEC.text;

        if (tachTEC.text == '') {
          tachycardia = tachycardia;
        } else
          tachycardia = tachTEC.text;

        if (bradTEC.text == '') {
          bradycardia = bradycardia;
        } else
          bradycardia = bradTEC.text;

        if (cvdTEC.text == '') {
          cvd = cvd;
        } else
          cvd = cvdTEC.text;
      },
    );
  }

  @override
  void initState() {
    // initialize functions
    getCurrentUser();
    getUserData(uid);
    super.initState();
  }

  void getCurrentUser() async {
    // find uid
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  getUserData(uid) async {
    // retrieve patient's data from Firestore
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
    setState(
      () {
        adr = patientInfo.get('address');
        age = patientInfo.get('age');
        conds = patientInfo.get('conds');
        dob = patientInfo.get('dob');
        first = patientInfo.get('first name');
        ht = patientInfo.get('ht');
        last = patientInfo.get('last name');
        meds = patientInfo.get('meds');
        province = patientInfo.get('province');
        sex = patientInfo.get('sex');
        tele = patientInfo.get('tele');
        wt = patientInfo.get('wt');
        diabetes = patientInfo.get('diabetes');
        tachycardia = patientInfo.get('tachycardia');
        bradycardia = patientInfo.get('bradycardia');
        hypertension = patientInfo.get('hypertension');
        hypotension = patientInfo.get('hypotension');
        cvd = patientInfo.get('cvd');
        highHR = patientInfo.get('highHR');
        lowHR = patientInfo.get('lowHR');
        highBG = patientInfo.get('highBG');
        lowBG = patientInfo.get('lowBG');
        highBP = patientInfo.get('highBP');
        lowBP = patientInfo.get('lowBP');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Edit my Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            textFieldLabel('First Name'),
            TextFormField(
              controller: firstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: first,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Last Name'),
            TextFormField(
              controller: lastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: last,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Age'),
            TextFormField(
              maxLength: 3,
              controller: ageTEC,
              keyboardType: TextInputType.number,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: age,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Date of Birth (DD-MM-YYYY)'),
            TextFormField(
              maxLength: 10,
              controller: dobTEC,
              keyboardType: TextInputType.datetime,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: dob,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFieldLabel('Province/Territory:    '),
                DropdownButton<String>(
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  value: province,
                  hint: Text(''),
                  style: kTextStyle2,
                  items: [
                    DropdownMenuItem(
                      child: Text(''),
                      value: '',
                    ),
                    DropdownMenuItem(
                      child: Text('AB'),
                      value: 'AB',
                    ),
                    DropdownMenuItem(
                      child: Text('BC'),
                      value: 'BC',
                    ),
                    DropdownMenuItem(
                      child: Text('MB'),
                      value: 'MB',
                    ),
                    DropdownMenuItem(
                      child: Text('NB'),
                      value: 'NB',
                    ),
                    DropdownMenuItem(
                      child: Text('NL'),
                      value: 'NL',
                    ),
                    DropdownMenuItem(
                      child: Text('NS'),
                      value: 'NS',
                    ),
                    DropdownMenuItem(
                      child: Text('NU'),
                      value: 'NU',
                    ),
                    DropdownMenuItem(
                      child: Text('NWT'),
                      value: 'NWT',
                    ),
                    DropdownMenuItem(
                      child: Text('ON'),
                      value: 'ON',
                    ),
                    DropdownMenuItem(
                      child: Text('PEI'),
                      value: 'PEI',
                    ),
                    DropdownMenuItem(
                      child: Text('QC'),
                      value: 'QC',
                    ),
                    DropdownMenuItem(
                      child: Text('SK'),
                      value: 'SK',
                    ),
                    DropdownMenuItem(
                      child: Text('YT'),
                      value: 'YT',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        province = value.toString();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFieldLabel('Sex:    '),
                DropdownButton<String>(
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  value: sex,
                  hint: Text(''),
                  style: kTextStyle2,
                  items: [
                    DropdownMenuItem(
                      child: Text(''),
                      value: '',
                    ),
                    DropdownMenuItem(
                      child: Text('M'),
                      value: 'M',
                    ),
                    DropdownMenuItem(
                      child: Text('F'),
                      value: 'F',
                    ),
                    DropdownMenuItem(
                      child: Text('X'),
                      value: 'X',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        sex = value.toString();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Height (Please specify if measured in cm or ft)'),
            TextFormField(
              controller: htTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ht,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Weight (Please specify if measured in lbs or kg)'),
            TextFormField(
              controller: wtTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: wt,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Medical Conditions (Please list all)'),
            TextFormField(
              controller: condsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: conds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Medications (Please list all)'),
            TextFormField(
              controller: medsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: meds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Telephone Number'),
            TextFormField(
              maxLength: 12,
              controller: teleTEC,
              keyboardType: TextInputType.phone,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: tele,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Home Address'),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: adrTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: adr,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),

            Text(
              'Do you have any of the following underlying health conditions...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFieldLabel('Diabetes:    '),
              DropdownButton<String>(
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                value: diabetes,
                hint: Text(''),
                style: kTextStyle2,
                items: [
                  DropdownMenuItem(
                    child: Text(''),
                    value: '',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes Type I'),
                    value: 'Yes Type I',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes Type II'),
                    value: 'Yes Type II',
                  ),
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 'No',
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      diabetes = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
              height: 10.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFieldLabel('Hypertension:    '),
              DropdownButton<String>(
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                value: hypertension,
                hint: Text(''),
                style: kTextStyle2,
                items: [
                  DropdownMenuItem(
                    child: Text(''),
                    value: '',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes'),
                    value: 'Yes',
                  ),
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 'No',
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      hypertension = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
              height: 10.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFieldLabel('Hypotension:    '),
              DropdownButton<String>(
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                value: hypotension,
                hint: Text(''),
                style: kTextStyle2,
                items: [
                  DropdownMenuItem(
                    child: Text(''),
                    value: '',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes'),
                    value: 'Yes',
                  ),
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 'No',
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      hypotension = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
              height: 10.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFieldLabel('Tachycardia:    '),
              DropdownButton<String>(
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                value: tachycardia,
                hint: Text(''),
                style: kTextStyle2,
                items: [
                  DropdownMenuItem(
                    child: Text(''),
                    value: '',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes'),
                    value: 'Yes',
                  ),
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 'No',
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      tachycardia = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
              height: 10.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFieldLabel('Bradycardia:    '),
              DropdownButton<String>(
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                value: bradycardia,
                hint: Text(''),
                style: kTextStyle2,
                items: [
                  DropdownMenuItem(
                    child: Text(''),
                    value: '',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes'),
                    value: 'Yes',
                  ),
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 'No',
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      bradycardia = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
              height: 10.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFieldLabel('Cardiovascular Disease:    '),
              DropdownButton<String>(
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                value: cvd,
                hint: Text(''),
                style: kTextStyle2,
                items: [
                  DropdownMenuItem(
                    child: Text(''),
                    value: '',
                  ),
                  DropdownMenuItem(
                    child: Text('Yes'),
                    value: 'Yes',
                  ),
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 'No',
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      cvd = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
           


            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: kCancel,
                    onPressed: () async {
                      setState(
                        () {
                          // if the user presses 'cancel', do not change any values
                          // in Firestore, even if there are new values in some text fields and exit page
                          adr = adr;
                          age = age;
                          conds = conds;
                          dob = dob;
                          first = first;
                          ht = ht;
                          last = last;
                          meds = meds;
                          tele = tele;
                          wt = wt;
                          diabetes = diabetes;
                          hypertension = hypertension;
                          hypotension = hypotension;
                          tachycardia = tachycardia;
                          bradycardia = bradycardia;
                          cvd = cvd;
                          highHR = highHR;
                          lowHR = lowHR;
                          highBG = highBG;
                          lowBG = lowBG;
                          highBP = highBP;
                          lowBP = lowBP;
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Text(
                      'Cancel',
                      style: kAppBarLabelStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: kConfirm,
                    onPressed: () async {

                      setState(
                        () {
                          // if the user presses confirm, update info in Firestore and exit page
                          showSpinner = true;
                          updateProfile();
                          updateThresholds();
                          DatabaseAuth(uid: loggedInUser.uid).updatePatientData(
                            adr,
                            age,
                            conds,
                            dob,
                            first,
                            ht,
                            last,
                            meds,
                            province,
                            sex,
                            tele,
                            wt,
                            diabetes,
                            hypertension,
                            hypotension,
                            tachycardia,
                            bradycardia,
                            cvd,
                            highHR,
                            lowHR,
                            highBG,
                            lowBG,
                            highBP,
                            lowBP,
                          );
                          Navigator.pop(
                            context,
                            {
                              adr,
                              age,
                              conds,
                              dob,
                              first,
                              ht,
                              last,
                              meds,
                              province,
                              sex,
                              tele,
                              wt,
                              diabetes,
                              hypertension,
                              hypotension,
                              tachycardia,
                              bradycardia,
                              cvd,
                              highHR,
                              lowHR,
                              highBG,
                              lowBG,
                              highBP,
                              lowBP,
                            },
                          );
                          setState(
                            () {
                              showSpinner = false;
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Confirm',
                      style: kAppBarLabelStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

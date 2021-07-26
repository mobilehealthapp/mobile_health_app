import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isValid = false;

final patientRef = FirebaseFirestore.instance.collection('patientData');
final _auth = FirebaseAuth.instance;
var loggedInUser;
var uid;

void getCurrentUser() async {
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

// To convert mg/dL to mmol/L
double glucoseConversion = 18.0182;

double convertGlucose(double data) {
  return data / glucoseConversion.toDouble();
}

double filterAlpha(String data) {
  print(1);
  String filteredData = data.replaceAll(RegExp(r'[^\d\.]'), '');
  print(filteredData);
  return double.parse(filteredData);
}

String bpAlertText(String type, data1, data2) {
  switch (type) {
    case 'Blood Pressure':
      if (data2 == null) {
        isValid = false;
        return 'Missing either the systolic or the diastolic measurement. \nPlease select both measurements.';
      } else {
        print(3);
        double sys = filterAlpha(data1);
        print(4);
        double dia = filterAlpha(data2);
        print(5);
        double systolic = (sys >= dia) ? sys : dia;
        double diastolic = (sys <= dia) ? sys : dia;
        isValid = true;
        return 'The recorded value for your blood pressure was: ${systolic.toInt()} systolic and ${diastolic.toInt()} diastolic. \n\nIs this correct?';
      }
    case 'Blood Glucose':
      double glucose = (data2 == 'mmol/L') ? data1 : convertGlucose(data1);
      isValid = true;
      return 'The recorded value for your blood glucose was: $data1 $data2. \n\nIs this correct?';
    case 'Heart Rate':
      isValid = true;
      return 'The recorded value for your heart rate was: $data1 bpm. \n\nIs this correct?';
    default:
      isValid = false;
      return 'Please select the appropriate data.';
  }
}

void processData(String type, data1, data2) {}

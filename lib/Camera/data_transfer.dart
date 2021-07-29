import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isValid = false;

final patientData = FirebaseFirestore.instance.collection('patientData');
final _auth = FirebaseAuth.instance;
var loggedInUser;
var uid;

String getCurrentTime() {
  return DateTime.now().toUtc().toString();
}

void getCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      uid = user.uid.toString();
    }
  } catch (e) {
    print(e);
  }
}

void processData(String type, data1, data2) {
  getCurrentUser();
  final userData = patientData.doc(uid);
  switch (type) {
    case 'Blood Pressure':
      double sys = filterAlpha(data1);
      double dia = filterAlpha(data2);
      double systolic = (sys >= dia) ? sys : dia;
      double diastolic = (sys <= dia) ? sys : dia;
      userData
          .collection('bloodPressure')
          .doc(getCurrentTime())
          .set({'systolic': systolic, 'diastolic': diastolic});
      break;
    case 'Blood Glucose':
      double filteredData = double.parse(filterAlpha(data1).toStringAsFixed(1));
      double convertedData =
          double.parse(convertGlucose(filteredData).toStringAsFixed(1));
      double glucose = (data2 == 'mmol/L') ? filteredData : convertedData;
      userData
          .collection('bloodGlucose')
          .doc(getCurrentTime())
          .set({'blood glucose': glucose});
      break;
    case 'Heart Rate':
      int filteredData = filterAlpha(data1.toString()).toInt();
      print(filteredData);
      userData
          .collection('heartRate')
          .doc(getCurrentTime())
          .set({'heart rate': filteredData});
      break;
    default:
      break;
  }
}

void recalculateAverage(String dataType) async {
  getCurrentUser();
  final userData = patientData.doc(uid);
  switch (dataType) {
    case 'Blood Pressure':
      QuerySnapshot<Map<String, dynamic>> queries =
          await userData.collection('bloodPressure').get();
      int numberOfDataPoints = queries.docs.length;
      double avgSystolic = 0;
      double avgDiastolic = 0;
      for (QueryDocumentSnapshot document in queries.docs) {
        avgSystolic += document.get('systolic');
        avgDiastolic += document.get('diastolic');
      }
      avgSystolic = avgSystolic / numberOfDataPoints;
      avgDiastolic = avgDiastolic / numberOfDataPoints;
      userData.set({
        'Average Blood Pressure (systolic)': avgSystolic.round(),
        'Average Blood Pressure (diastolic)': avgDiastolic.round(),
      }, SetOptions(merge: true));
      break;
    case 'Blood Glucose':
      QuerySnapshot<Map<String, dynamic>> queries =
          await userData.collection('bloodGlucose').get();
      int numberOfDataPoints = queries.docs.length;
      double avgGlucose = 0;
      for (QueryDocumentSnapshot document in queries.docs) {
        avgGlucose += document.get('blood glucose');
      }
      avgGlucose = avgGlucose / numberOfDataPoints;
      userData.set({
        'Average Blood Glucose': double.parse(avgGlucose.toStringAsFixed(1)),
      }, SetOptions(merge: true));
      break;
    case 'Heart Rate':
      QuerySnapshot<Map<String, dynamic>> queries =
          await userData.collection('heartRate').get();
      int numberOfDataPoints = queries.docs.length;
      double avgHeartRate = 0;
      for (QueryDocumentSnapshot document in queries.docs) {
        avgHeartRate += document.get('heart rate');
      }
      avgHeartRate = avgHeartRate / numberOfDataPoints;
      userData.set({
        'Average Heart Rate': avgHeartRate.round(),
      }, SetOptions(merge: true));
      break;
  }
}

// To convert mg/dL to mmol/L
double glucoseConversion = 18.0182;

double convertGlucose(double data) {
  return (data / glucoseConversion).toDouble();
}

double filterAlpha(String data) {
  String filteredData = data.replaceAll(RegExp(r'[^\d\.]'), '');
  return double.parse(filteredData);
}

String ocrAlertText(String type, data1, data2) {
  switch (type) {
    case 'Blood Pressure':
      if (data2 == null) {
        isValid = false;
        return 'Missing either the systolic or the diastolic measurement. \nPlease select both measurements.';
      } else {
        double sys = filterAlpha(data1);
        double dia = filterAlpha(data2);
        double systolic = (sys >= dia) ? sys : dia;
        double diastolic = (sys <= dia) ? sys : dia;
        isValid = true;
        return 'The recorded value for your blood pressure was: ${systolic.toInt()} systolic and ${diastolic.toInt()} diastolic. \n\nIs this correct?';
      }
    case 'Blood Glucose':
      double glucose = filterAlpha(data1);
      isValid = true;
      return 'The recorded value for your blood glucose was: $glucose $data2. \n\nIs this correct?';
    case 'Heart Rate':
      double bpm = filterAlpha(data1);
      isValid = true;
      return 'The recorded value for your heart rate was: ${bpm.toInt()} bpm. \n\nIs this correct?';
    default:
      isValid = false;
      return 'Please select the appropriate data.';
  }
}

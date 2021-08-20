import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firestore variables
final patientData = FirebaseFirestore.instance.collection('patientData');
final _auth = FirebaseAuth.instance;
var loggedInUser;
var uid;

// Function to get the current time
// (returns a DateTime, simply convert to String if desired)
DateTime getCurrentTime() {
  return DateTime.now().toUtc();
}

// Function to get the uid of a current user
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

// Constant to convert mg/dL to mmol/L
double glucoseConversion = 18.0182;

// Function that returns a converted value of a glucose measurement
// the string conversion is either "mmol/L" or "mg/dL"
double convertGlucose(double data, String conversion) {
  // convert to mmol/L
  if (conversion == "mmol/L") {
    return (data / glucoseConversion).toDouble();
  } else {
    // convert to mg/dL
    return (data * glucoseConversion).toDouble();
  }
}

// Function that filters out all non-numeric characters from a string
double filterAlpha(String data) {
  String filteredData = data.replaceAll(RegExp(r'[^\d\.]'), '');
  return double.parse(filteredData);
}

// Custom class for Data, it contains three fields: type (the data type), data1,
// and data2.
// For blood pressure: data1 and data2 are systolic and diastolic (in no particular order)
// For blood glucose: data1 = measurement, data2 = glucose unit (in form of string)
// For heart rate: data1 = bpm, data2 = null
class Data {
  String? type;
  var data1;
  var data2;
  Data(this.type, this.data1, this.data2);

  bool isValid = false;

  // Function that inputs a Data that corresponds to the manually entered data
  // on the data input page and returns true if the current Data is the same
  // as the inputted data, and false otherwise
  // This function is called on a Data class object.
  bool isSame(Data inputtedData) {
    var d1 = data1;
    var d2 = data2;
    if (data1 != null) {
      d1 = filterAlpha(data1);
    }
    if (data2 != null && type != "Blood Glucose") {
      d2 = filterAlpha(data2);
    }

    if (type == "Blood Pressure") {
      var sys = (d1 > d2) ? d1 : d2;
      var dia = (d1 < d2) ? d1 : d2;
      d1 = sys;
      d2 = dia;
    }
    if (type == inputtedData.type &&
        d1 == inputtedData.data1 &&
        d2 == inputtedData.data2) {
      return true;
    } else {
      return false;
    }
  }

  // Function that uploads the data to the database
  void processData() {
    getCurrentUser(); // sets uid to the current user's uid
    final userData = patientData.doc(uid); // location to patient's data
    final date = getCurrentTime().toString();
    switch (type) {
      case 'Blood Pressure':
        // get filtered systolic and diastolic
        double sys = filterAlpha(data1);
        double dia = filterAlpha(data2);
        double systolic = (sys >= dia) ? sys : dia;
        double diastolic = (sys <= dia) ? sys : dia;

        // Creates a document under patientData/$uid/bloodPressure/
        // the documentID is the current date, and it contains fields for
        // systolic, diastolic, and uploaded (where uploaded is the date)
        userData.collection('bloodPressure').doc(date).set({
          "systolic": systolic,
          "diastolic": diastolic,
          "uploaded": date,
        });
        break;
      case 'Blood Glucose':
        // get filtered glucose data
        double filteredData =
            double.parse(filterAlpha(data1).toStringAsFixed(1));

        // perform conversions
        double convertedMMOL = double.parse(
            convertGlucose(filteredData, "mmol/L").toStringAsFixed(1));
        double glucoseMMOL = (data2 == "mmol/L") ? filteredData : convertedMMOL;

        double convertedMG = double.parse(
            convertGlucose(filteredData, "mg/dL").toStringAsFixed(1));
        double glucoseMG = (data2 == "mg/dL") ? filteredData : convertedMG;

        // Creates a document under patientData/$uid/bloodGlucose/
        // the documentID is the current date, and it contains fields for
        // blood glucose (mmol|L), blood glucose (mg|dL),
        // and uploaded (where uploaded is the date)
        // Note: the field names cannot contain "/" in them, hence why "|" was used
        userData.collection('bloodGlucose').doc(date).set({
          "blood glucose (mmol|L)": glucoseMMOL,
          "blood glucose (mg|dL)": glucoseMG,
          "uploaded": date,
        });
        break;
      case 'Heart Rate':
        // get filtered heart rate data
        int filteredData = filterAlpha(data1.toString()).toInt();

        // Creates a document under patientData/$uid/heartRate/
        // the documentID is the current date, and it contains fields for
        // heart rate and uploaded (where uploaded is the date)
        userData.collection('heartRate').doc(date).set({
          'heart rate': filteredData,
          "uploaded": date,
        });
        break;
      default:
        break;
    }
  }

  // Function that returns the appropriate alert text once the user hits submit
  String ocrAlertText() {
    switch (type) {
      case 'Blood Pressure':
        // missing a data point
        if (data2 == null) {
          isValid = false;
          return 'Missing either the systolic or the diastolic measurement. \nPlease select both measurements.';
        } else {
          // valid blood pressure data
          double sys = filterAlpha(data1);
          double dia = filterAlpha(data2);
          double systolic = (sys >= dia) ? sys : dia;
          double diastolic = (sys <= dia) ? sys : dia;
          isValid = true;
          return 'The recorded value for your blood pressure was: ${systolic.toInt()} systolic and ${diastolic.toInt()} diastolic. \n\nIs this correct?';
        }
      case 'Blood Glucose':
        // valid blood glucose data
        double glucose = filterAlpha(data1);
        isValid = true;
        return 'The recorded value for your blood glucose was: $glucose $data2. \n\nIs this correct?';
      case 'Heart Rate':
        // valid heart rate data
        double bpm = filterAlpha(data1);
        isValid = true;
        return 'The recorded value for your heart rate was: ${bpm.toInt()} bpm. \n\nIs this correct?';
      default:
        isValid = false;
        return 'Please select the appropriate data.';
    }
  }

  // Function that recalculates the average data fields in a user's
  // patientData document
  void recalculateAverage() async {
    getCurrentUser();
    final userData = patientData.doc(uid);
    switch (type) {
      case 'Blood Pressure':
        // get all blood pressure data points
        QuerySnapshot<Map<String, dynamic>> queries =
            await userData.collection('bloodPressure').get();

        // number of data points
        int numberOfDataPoints = queries.docs.length;

        // Calculate the average
        double avgSystolic = 0;
        double avgDiastolic = 0;
        for (QueryDocumentSnapshot document in queries.docs) {
          avgSystolic += document.get('systolic');
          avgDiastolic += document.get('diastolic');
        }
        avgSystolic = avgSystolic / numberOfDataPoints;
        avgDiastolic = avgDiastolic / numberOfDataPoints;

        // set the average values
        userData.set({
          'Average Blood Pressure (systolic)': avgSystolic.round(),
          'Average Blood Pressure (diastolic)': avgDiastolic.round(),
        }, SetOptions(merge: true));
        break;
      case 'Blood Glucose':
        // get all blood glucose data points
        QuerySnapshot<Map<String, dynamic>> queries =
            await userData.collection('bloodGlucose').get();

        // number of data points
        int numberOfDataPoints = queries.docs.length;

        // Calculate the average
        double avgGlucoseMMOL = 0;
        double avgGlucoseMG = 0;
        for (QueryDocumentSnapshot document in queries.docs) {
          avgGlucoseMMOL += document.get("blood glucose (mmol|L)");
          avgGlucoseMG += document.get("blood glucose (mg|dL)");
        }
        avgGlucoseMMOL = avgGlucoseMMOL / numberOfDataPoints;
        avgGlucoseMG = avgGlucoseMG / numberOfDataPoints;

        // set the average values
        userData.set({
          "Average Blood Glucose (mmol|L)":
              double.parse(avgGlucoseMMOL.toStringAsFixed(1)),
          "Average Blood Glucose (mg|dL)":
              double.parse(avgGlucoseMG.toStringAsFixed(0))
        }, SetOptions(merge: true));
        break;
      case 'Heart Rate':
        // get all heart rate data points
        QuerySnapshot<Map<String, dynamic>> queries =
            await userData.collection('heartRate').get();

        // number of data points
        int numberOfDataPoints = queries.docs.length;

        // Calculate the average
        double avgHeartRate = 0;
        for (QueryDocumentSnapshot document in queries.docs) {
          avgHeartRate += document.get('heart rate');
        }
        avgHeartRate = avgHeartRate / numberOfDataPoints;

        // set the average values
        userData.set({
          'Average Heart Rate': avgHeartRate.round(),
        }, SetOptions(merge: true));
        break;
    }
  }
}

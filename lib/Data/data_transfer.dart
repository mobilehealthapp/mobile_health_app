import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/Notification/notifications.dart';


// Firestore variables
final patientData = FirebaseFirestore.instance.collection('patientData');
var userData;
final _auth = FirebaseAuth.instance;
var loggedInUser;
var uid;
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

  void dataInsert(String subcollection, final date, num measurement1,
      num? measurement2) async {
    num measurements = 0;
    bool noentries = false;
    bool lastentry = false;
    DocumentSnapshot snapshot = await userData
        .collection(subcollection)
        .doc("Last 100 Recordings")
        .get();
    if (snapshot.exists) {
      // if the user has data entries check how many there are
      num entries = snapshot.get('Data Entries');
      if (entries == 99) {
        await adjustData(subcollection, snapshot.data());
        noentries = true;
      } else {
        if (entries == 98) {
          lastentry = true;
        }
        measurements =
            entries; //for measurements, the greater the measurement the longer ago it was taken
      }
    } else {
      noentries = true;
    }
    measurements++;
    String insertion;
    if (measurements < 10) {
      insertion =
          "Data Submission 0$measurements"; //helps with layout inside database
    } else {
      insertion = "Data Submission $measurements";
    }
    String data;
    if (measurement2 != null) {
      //puts the data and date into a parsable String
      data = "$measurement1,$measurement2,-$date";
    } else {
      data = "$measurement1,-$date";
    }
    // Creates a document under patientData/$uid/subcollection/
    // that holds the last 100 data entries
    if (noentries) {
      //if user has no data Entries in their last 100 put this as the oldest date
      userData.collection(subcollection).doc("Last 100 Recordings").set({
        'Oldest Date': date,
        'Data Entries': measurements,
        insertion: data,
      });
    } else if (lastentry) {
      //if this is the last entry of this document include it's date
      userData.collection(subcollection).doc("Last 100 Recordings").update({
        'Most Recent Date': date,
        'Data Entries': measurements,
        insertion: data,
      });
    } else {
      userData.collection(subcollection).doc("Last 100 Recordings").update({
        'Data Entries': measurements,
        insertion: data,
      });
    }
  }

  Future<void> adjustData(String subcollection, Object? data) async {
    //creates the document for the next one hundred values
    var subcol = userData.collection(subcollection);
    num newspot = 0;
    DocumentSnapshot snapshot = await userData.get();
    if (snapshot.exists) {
      if (snapshot.get("$subcollection Recordings (hundreds)") > 0) {
        newspot = snapshot.get("$subcollection Recordings (hundreds)");
        print(newspot);
      }
    }
    num bottom = newspot * 100;
    num top = (newspot + 1) * 100;
    newspot++; //increment newspot to update the hundreds readings count for this subcollection
    String newdoc = bottom.toString() + "~" + top.toString() + " Recordings";
    subcol.doc(newdoc).set(data);
    // saves the last 100 measurements to a new document
    // deletes the old document
    subcol.doc("Last 100 Recordings").delete();
    userData.update(
      {
        "$subcollection Recordings (hundreds)":
            newspot, //update document readings (hundreds)
      },
    );
  }

  // Function that uploads the data to the database
  void processData() async {
    getCurrentUser(); // sets uid to the current user's uid
    userData = patientData.doc(uid); // location to patient's data
    final date = getCurrentTime().toString();
    switch (type) {
      case 'Blood Pressure':
        // get filtered systolic and diastolic
        double sys = filterAlpha(data1);
        double dia = filterAlpha(data2);
        double systolic = (sys >= dia) ? sys : dia;
        double diastolic = (sys <= dia) ? sys : dia;
        //inserts latest recording into the last 100 recordings document in the bloodPressure subcollection
        //in the format systolic,diastolic,-date
        dataInsert('bloodPressure', date, systolic, diastolic);
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
        //inserts latest recording into the last 100 recordings document in the bloodGlucose subcollection
        //in the format MG,MMOL,-date
        dataInsert('bloodPressure', date, glucoseMG, glucoseMMOL);
        break;
      case 'Heart Rate':
        // get filtered heart rate data
        int filteredData = filterAlpha(data1.toString()).toInt();
        //inserts latest recording into the last 100 recordings document in the heartRate subcollection
        //in the format heartRate,-date
        dataInsert('heartRate', date, filteredData, null);
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

  //Set of functions to notify the physician if inputted values exceed the threshold values
  //TODO: Add notifications for predictive values- framework is created below

  Future bpNotification() async {
    if ( data1 > highSYS || data1 < lowSYS || data2 > highDIA || data2 < lowDIA ) {
      NotificationApi.showNotification(
        title: 'Exceeds Blood Pressure Threshold',
        body: ' Your patient\'s Blood Pressure exceeds the threshold amount. Click here to view your patients profile.',
        payload: '/physHome',
      );
    }
  }

  Future glucoseNotification() async {
    if ( data1 > highBG || data1 < lowBG  ) {
      NotificationApi.showNotification(
          title: 'Exceeds Blood Glucose Threshold',
          body: ' Your patient\'s Blood Glucose exceeds the threshold amount. Click here to view your patients profile.',
          payload: '/physHome',
      );
    }
  }
  Future heartRateNotification() async {
    if (  data1 > highHR || data1 < lowHR ) {
      NotificationApi.showNotification(
          title: 'Exceeds Heart Rate Threshold',
          body: ' Your patient\'s Heart Rate exceeds the threshold amount. Click here to view your patients profile.',
          payload: '/physHome',
      );
    }
  }

/*  Future bpPredictiveThreshold() async {
    if (  /*  Within Threshold  */ ) {
      NotificationApi.showNotification(
        title: 'Predicted Blood Pressure Threshold',
        body: ' Your patient\'s Blood Pressure is predicted to exceed the threshold. Click here to view your patients profile.',
        payload: '/physHome',
      );
    }
  }

  Future glucosePredictiveThreshold() async {
    if (  /*  Within Threshold  */ ) {
      NotificationApi.showNotification(
        title: 'Predicted Blood Glucose Threshold',
        body: ' Your patient\'s Blood Glucose is predicted to exceed the threshold. Click here to view your patients profile.',
        payload: '/physHome',
      );
    }
  }
  Future heartRatePredictiveThreshold() async {
    if (  /*  Within Threshold  */ ) {
      NotificationApi.showNotification(
        title: 'Predicted Heart Rate Threshold',
        body: ' Your patient\'s Heart Rate is predicted to exceed the threshold. Click here to view your patients profile. ',
        payload: '/physHome',
      );
    }
  } */
}

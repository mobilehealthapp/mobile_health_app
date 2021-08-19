import 'package:cloud_firestore/cloud_firestore.dart';
import 'health_analysis_form.dart';

// These are the functions used in the health analysis form
// Be warned: the numbers used are not reputable, this was mostly
// a proof-of-concept feature and should be expanded on properly

String idealBP = '';
double idealBG = 0.0;
bool? diabetes;

// Current user's patientData folder
final patientData = FirebaseFirestore.instance.collection('patientData');

// getIdealBP sets the constant idealBP to be the ideal blood pressure
// given the inputted age, sex, and whether or not the patient is diabetic
void getIdealBP(int age, String sex, bool diabetic) {
  if (diabetic) {
    diabetes = true;
    if (age >= 80) {
      idealBP = "150/90";
    } else if (age >= 70) {
      idealBP = "140/90";
    } else {
      idealBP = "130/80";
    }
  } else {
    diabetes = false;
    if (age <= 1) {
      idealBP = "90/60";
    } else if (age <= 5) {
      idealBP = "95/65";
    } else if (age <= 13) {
      idealBP = "105/70";
    } else if (age <= 19) {
      idealBP = "117/77";
    } else if (age <= 24) {
      idealBP = "120/79";
    } else if (age <= 29) {
      idealBP = "121/80";
    } else if (age <= 34) {
      idealBP = "122/81";
    } else if (age <= 39) {
      idealBP = "123/82";
    } else if (age <= 44) {
      idealBP = "125/83";
    } else if (age <= 49) {
      idealBP = "127/84";
    } else if (age <= 54) {
      idealBP = "129/85";
    } else if (age <= 59) {
      idealBP = "131/86";
    } else {
      idealBP = "134/87";
    }
  }
}

// getAverageResults retrieves the user's average blood pressure from
// the database and calculates the percent different (w/ respect to the
// idealBP) and also determines if the patient is hypertensive
Future<String> getAverageResults(uid) async {
  final DocumentSnapshot patientDoc =
      await FirebaseFirestore.instance.collection("patientData").doc(uid).get();

  // get average values
  int patientSystolic = patientDoc.get('Average Blood Pressure (systolic)');
  int patientDiastolic = patientDoc.get('Average Blood Pressure (diastolic)');

  List<String> idealBloodPressure = idealBP.split("/");

  // percent difference calculations
  double percentageSys =
      (patientSystolic - int.parse(idealBloodPressure[0])).abs() /
          int.parse(idealBloodPressure[0]) *
          100;
  double percentageDia =
      (patientDiastolic - int.parse(idealBloodPressure[1])).abs() /
          int.parse(idealBloodPressure[1]) *
          100;
  int avgPercentageBP =
      int.parse(((percentageDia + percentageSys) / 2).toStringAsFixed(0));

  // warning will remain false unless the patient's average BP is above 150/90mmHg
  warning = false;
  if (patientSystolic >= 150 || patientDiastolic >= 90) {
    print("warning");
    warning = true;
    warningText =
        'Warning: your average blood pressure is above 150/90 mmHg. This is considered to be hypertension, please contact your physician.';
  }

  // Summary message for the summary card on the health analysis form
  return 'Your average blood pressure is $patientSystolic/$patientDiastolic mmHg \n\nThis is roughly $avgPercentageBP% away from the ideal blood pressure of $idealBP mmHg for your demographic.';
}

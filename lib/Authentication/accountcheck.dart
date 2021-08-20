import 'package:cloud_firestore/cloud_firestore.dart';

//In this file we have two functions that must be used in the splash screen to determine user's account type
Future<bool> patientAccountCheck(uid) async {
  var patientDocumentReference = FirebaseFirestore.instance
      .collection('patientprofile')
      .doc(
          uid); //Searches for document reference in patientprofile collection with user's UID
  var patientCheck = await patientDocumentReference.get(); //reads document
  return patientCheck
      .exists; //returns True if document exists (user is a patient), False if document does not exist (user is not a patient).
}

Future<bool> doctorAccountCheck(uid) async {
  var doctorDocumentReference =
      FirebaseFirestore.instance.collection('doctorprofile').doc(uid);
  var doctorCheck = await doctorDocumentReference.get();
  return doctorCheck
      .exists; //This function is identical to patientAccountCheck except it checks doctorprofile collection and returns true if user is a doctor.
}

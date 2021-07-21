import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> patientAccountCheck(uid) async {
  var patientDocumentReference =
      FirebaseFirestore.instance.collection('patientprofile').doc(uid);
  var patientCheck = await patientDocumentReference.get();
  return patientCheck.exists;
}

Future<bool> doctorAccountCheck(uid) async {
  var doctorDocumentReference =
      FirebaseFirestore.instance.collection('doctorprofile').doc(uid);
  var doctorCheck = await doctorDocumentReference.get();
  return doctorCheck.exists;
}

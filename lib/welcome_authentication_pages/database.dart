import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  var uid;
  Database({this.uid});

  final CollectionReference patientProfileCollection =
      FirebaseFirestore.instance.collection('patientprofile');

  final CollectionReference doctorProfileCollection =
      FirebaseFirestore.instance.collection('doctorprofile');

  Future updatePatientData(String firstName, String lastName, String email,
      String accountType) async {
    return await patientProfileCollection.doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'account type': accountType
    });
  }

  Future updateDoctorData(String firstName, String lastName, String email,
      String accountType) async {
    return await doctorProfileCollection.doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'account type': accountType
    });
  }
}

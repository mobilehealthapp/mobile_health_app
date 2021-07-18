import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  var uid;
  Database({this.uid});
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference patientProfileCollection =
      FirebaseFirestore.instance.collection('patientprofile');

  final CollectionReference doctorProfileCollection =
      FirebaseFirestore.instance.collection('doctorprofile');

  final CollectionReference patientInfoCollection =
      FirebaseFirestore.instance.collection('patientprofile');

  final CollectionReference doctorInfoCollection =
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

  Future updatePatientInfo(
    String first,
    String last,
    String age,
    String dob,
    String sexChoose,
    String ht,
    String wt,
    String conds,
    String meds,
    String tele,
    String adr,
  ) async {
    return await patientProfileCollection.doc(uid).set({
      'first name': first,
      'last name': last,
      'age': age,
      'dob': dob,
      'sex': sexChoose,
      'wt': wt,
      'ht': ht,
      'tele': tele,
      'conds': conds,
      'meds': meds,
      'address': adr,
    });
  }

  Future updateDoctorInfo(
    String first,
    String last,
    String tele,
    String adr,
    String fax,
  ) async {
    return await doctorProfileCollection.doc(uid).set({
      'first name': first,
      'last name': last,
      'tele': tele,
      'fax': fax,
      'clinic address': adr,
    });
  }
}

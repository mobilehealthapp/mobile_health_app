import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid;

  DatabaseAuth({this.uid});

  final CollectionReference patientProfileCollection =
      FirebaseFirestore.instance.collection('patientprofile');

  final CollectionReference doctorProfileCollection =
      FirebaseFirestore.instance.collection('doctorprofile');

  Future setPatientData(String firstName, String lastName, String email,
      String accountType) async {
    return await patientProfileCollection.doc(uid).set(
      {
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'account type': accountType,
        'address': '',
        'age': '',
        'tele': '',
        'meds': '',
        'conds': '',
        'sex': 'Sex',
        'wt': '',
        'ht': '',
        'dob': '',
      },
    );
  }

  Future setDoctorData(String firstName, String lastName, String email,
      String accountType) async {
    return await doctorProfileCollection.doc(uid).set(
      {
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'account type': accountType,
        'clinicAddress': '',
        'quali': '',
        'tele': '',
        'fax': '',
      },
    );
  }

  Future deleteDoctorData(
      String email, String password, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      await user!.reauthenticateWithCredential(credentials);
      print(user);
      await doctorProfileCollection.doc(uid).update(
        {
          'first name': '',
          'last name': '',
          'clinicAddress': '',
          'quali': '',
          'tele': '',
          'fax': '',
          // 'first name': FieldValue.delete(),
          // 'last name': FieldValue.delete(),
          // 'clinicAddress': FieldValue.delete(),
          // 'quali': FieldValue.delete(),
          // 'tele': FieldValue.delete(),
          // 'fax': FieldValue.delete(),
        },
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/physHome', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
    return patientProfileCollection.doc(_auth.currentUser!.uid).delete();
  }

  Future deletePatientData(
      String email, String password, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      await user!.reauthenticateWithCredential(credentials);
      await patientProfileCollection.doc(_auth.currentUser!.uid).update(
        {
          'first name': '',
          'last name': '',
          'address': '',
          'age': '',
          'tele': '',
          'meds': '',
          'conds': '',
          'sex': 'Sex',
          'wt': '',
          'ht': '',
          'dob': '',
          // 'first name': FieldValue.delete(),
          // 'last name': FieldValue.delete(),
          // 'address': FieldValue.delete(),
          // 'age': FieldValue.delete(),
          // 'tele': FieldValue.delete(),
          // 'meds': FieldValue.delete(),
          // 'conds': FieldValue.delete(),
          // 'sex': FieldValue.delete(),
          // 'wt': FieldValue.delete(),
          // 'ht': FieldValue.delete(),
          // 'dob': FieldValue.delete(),
        },
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future deletePatientUser(
      String email, String password, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      var result = await user!.reauthenticateWithCredential(credentials);
      await erasePatientDocument();
      await result.user!.delete();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future deleteDoctorUser(
      String email, String password, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      var result = await user!.reauthenticateWithCredential(credentials);
      await eraseDoctorDocument();
      await result.user!.delete();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  //stream
  Stream<QuerySnapshot> get patient {
    return patientProfileCollection.snapshots();
  }

  Future updatePatientData(String firstName, lastName, age, dob, sex, ht, wt,
      conds, meds, tele, adr) async {
    return await patientProfileCollection.doc(_auth.currentUser!.uid).update(
      {
        'first name': firstName,
        'last name': lastName,
        'age': age,
        'dob': dob,
        'sex': sex,
        'ht': ht,
        'wt': wt,
        'conds': conds,
        'meds': meds,
        'tele': tele,
        'address': adr,
      },
    );
  }

  Future updateDoctorData(
      String firstName, lastName, quali, fax, tele, adr) async {
    return await doctorProfileCollection.doc(_auth.currentUser!.uid).update(
      {
        'first name': firstName,
        'last name': lastName,
        'quali': quali,
        'tele': tele,
        'clinicAddress': adr,
        'fax': fax,
      },
    );
  }

  Future erasePatientDocument() async {
    return await patientProfileCollection.doc(_auth.currentUser!.uid).delete();
  }

  Future eraseDoctorDocument() async {
    return await doctorProfileCollection.doc(_auth.currentUser!.uid).delete();
  }
}

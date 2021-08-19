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

  final CollectionReference patientDataCollection =
      FirebaseFirestore.instance.collection('patientData');

  final CollectionReference patientDoctorsCollection = FirebaseFirestore
      .instance
      .collection('patientprofile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('patientDoctors');

  final CollectionReference doctorProfileCollection =
      FirebaseFirestore.instance.collection('doctorprofile');

  final CollectionReference doctorPatientsCollection =
      FirebaseFirestore.instance.collection('doctorprofile');

  Future setPatientData(String firstName, String lastName, String email,
      String accountType) async {
    return await patientProfileCollection.doc(uid).set(
      {
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'account type': accountType,
        'province': '',
        'address': '',
        'age': '',
        'tele': '',
        'meds': '',
        'conds': '',
        'sex': '',
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
        'province': '',
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
      // TODO: edit function so that it also deletes doctor's document from each of their patients' Firestore collections
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      await user!.reauthenticateWithCredential(credentials);
      print(user);
      await doctorProfileCollection.doc(uid).update(
        {
          'first name': '',
          'last name': '',
          'province': '',
          'clinicAddress': '',
          'quali': '',
          'tele': '',
          'fax': '',
        },
      );
      /*
      when the user inputs the correct credentials and they are verified by Firebase Auth,
      they will delete all of their data from Firestore except for their account type and email address
      the document itself is not deleted as it is still attached to their uid, but all fields being
      deleted within the document are set to blank (set to ' ')
       */
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/physHome', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        // if the credentials are not correct, a fluttertoast message explaining the error shows up
        // to ask the user to reenter the correct email and password
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
    return patientProfileCollection.doc(_auth.currentUser!.uid).delete();
  }

  Future setDoctorCode(String physicianCode) async {
    return await doctorProfileCollection
        .doc(uid)
        .update({'access code': physicianCode});
  }

  Future deletePatientData(
      String email, String password, BuildContext context) async {
    try {
      // TODO: edit function so that it also deletes patient's document from each of their physicians' Firestore collections
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      await user!.reauthenticateWithCredential(credentials);
      await patientDataCollection.doc(_auth.currentUser!.uid).delete();
      await patientDoctorsCollection.get().then(
        (snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        },
      );
      await patientProfileCollection.doc(_auth.currentUser!.uid).update(
        {
          'first name': '',
          'last name': '',
          'province': '',
          'address': '',
          'age': '',
          'tele': '',
          'meds': '',
          'conds': '',
          'sex': '',
          'wt': '',
          'ht': '',
          'dob': '',
        },
      );
      /*
      when the user inputs the correct credentials and they are verified by Firebase Auth,
      they will delete all of their data from Firestore except for their account type and email address
      the document itself is not deleted as it is still attached to their uid, but all fields being
      deleted within the document are set to blank (set to ' ')
       */
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        // if the credentials are not correct, a fluttertoast message explaining the error shows up
        // to ask the user to reenter the correct email and password
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future deletePatientUser(
      String email, String password, BuildContext context) async {
    try {
      // TODO: edit function so that it also deletes patient's document from each of their physicians' Firestore collections
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      var result = await user!.reauthenticateWithCredential(credentials);
      await erasePatientDocument();
      await result.user!.delete();
      /*
      when the user inputs the correct credentials and they are verified by Firebase Auth,
      all of the data attached to their uid will be deleted, along with their account itself
       */
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        // if the credentials are not correct, a fluttertoast message explaining the error shows up
        // to ask the user to reenter the correct email and password
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future deleteDoctorUser(
      String email, String password, BuildContext context) async {
    try {
      // TODO: edit function so that it also deletes doctor's document from each of their patients' Firestore collections
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      var result = await user!.reauthenticateWithCredential(credentials);
      await eraseDoctorDocument();
      await result.user!.delete();
      /*
      when the user inputs the correct credentials and they are verified by Firebase Auth,
      all of the data attached to their uid will be deleted, along with their account itself
       */
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'The email address and/or password is incorrect. Please try again.',
        // if the credentials are not correct, a fluttertoast message explaining the error shows up
        // to ask the user to reenter the correct email and password
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

  Future updatePatientData(String adr, age, conds, dob, firstName, ht, lastName,
      meds, province, sex, tele, wt) async {
    /* used in patient profile edit page to update their data in Firestore once they
    press confirm
     */
    return await patientProfileCollection.doc(_auth.currentUser!.uid).update(
      {
        'first name': firstName,
        'last name': lastName,
        'province': province,
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
      String adr, firstName, lastName, fax, tele, province, quali) async {
    /* used in doctor profile edit page to update their data in Firestore once they
    press confirm
     */
    return await doctorProfileCollection.doc(_auth.currentUser!.uid).update(
      {
        'first name': firstName,
        'last name': lastName,
        'province': province,
        'quali': quali,
        'tele': tele,
        'clinicAddress': adr,
        'fax': fax,
      },
    );
  }

  Future erasePatientDocument() async {
    /* used in the delete my account function to delete document associated with
    patient's uid
     */
    await patientProfileCollection.doc(_auth.currentUser!.uid).delete();
    await patientDataCollection.doc(_auth.currentUser!.uid).delete();
    await patientDoctorsCollection.get().then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      },
    );
  }

  Future eraseDoctorDocument() async {
    /* used in the delete my account function to delete document associated with
    doctor's uid
     */
    await doctorProfileCollection.doc(_auth.currentUser!.uid).delete();
  }
}

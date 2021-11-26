import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_health_app/Analysis/health_analysis.dart';
//Class containing various functions for database and authentication operations in Firebase

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

  final CollectionReference doctorPatientsCollection = FirebaseFirestore
      .instance
      .collection('doctorprofile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('doctorPatients');

  Future setPatientData(String firstName, String lastName, String email,
      String accountType) async {
    await patientDataCollection.doc(uid).set({
      "bloodGlucose Recordings (hundreds)": 0,
      "bloodPressure Recordings (hundreds)": 0,
      "heartRate Recordings (hundreds)": 0,
    });
    await patientProfileCollection.doc(uid).set(
      //Called on sign-up, this function creates a document within the patient profile collection and populates it with initial patient data.
      // The document's ID matches the UID of the user for convenience of user data management
      //Fields with empty strings can be edited later by users from the profile page
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
        'diabetes': '',
        'hypertension': '',
        'hypotension': '',
        'tachycardia': '',
        'bradycardia': '',
        'cvd': '',
        'highHR': ' ',
        'lowHR': ' ',
        'highBG': ' ',
        'lowBG': ' ',
        'highBP': ' ',
        'lowBP': ' ',
      },
    );
  }

  Future setDoctorData(String firstName, String lastName, String email,
      String accountType) async {
    return await doctorProfileCollection.doc(uid).set(
      //Identical to setPatientData but for doctor accounts
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
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      await user!.reauthenticateWithCredential(credentials);
      print(user);
      await updateDoctorData('', '', '', '', '', '', '');
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
  }

  Future setDoctorCode(String physicianCode) async {
    return await doctorProfileCollection
        .doc(uid)
        .update({'access code': physicianCode});
  }

  Future deletePatientData(
      String email, String password, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      await user!.reauthenticateWithCredential(credentials);
      dataDelete('bloodGlucose', 1);
      dataDelete('bloodPressure', 1);
      dataDelete('heartRate', 0); //patientData fields are emptied here
      await updatePatientData('', '', '', '', '', '', '', '', '', '', '',
          '', '', '', '', '', '', '', '', '', '', '', '', ''); //updates patientProfile field and doctorPatients fields
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
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      var result = await user!.reauthenticateWithCredential(credentials);
      await erasePatientDocument(); //deletes patient from doctorPatients, patientData, and patientProfile collections
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
      meds, province, sex, tele, wt, diabetes, hypertension, hypotension, 
      tachycardia, bradycardia, cvd, highHR, lowHR, highBG, lowBG, highBP, lowBP) async {
    /* used in patient profile edit page to update their data in Firestore once they
    press confirm
     */
    await patientProfileCollection.doc(_auth.currentUser!.uid).update(
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
        'diabetes': diabetes,
        'hypertension': hypertension,
        'hypotension': hypotension,
        'tachycardia': tachycardia,
        'bradycardia': bradycardia,
        'cvd': cvd,
        'highHR': highHR,
        'lowHR': lowHR,
        'highBG': highBG,
        'lowBG': lowBG,
        'highBP': highBP,
        'lowBP': lowBP,
      },
    );
    patientDoctorsCollection.get().then((docSnapshot) => {
          //if the patient has a doctor, update their doctor(s)'s doctorPatients form
          if (docSnapshot.size > 0)
            {
              docSnapshot.docs.forEach((DocumentSnapshot doc) {
                doctorProfileCollection
                    .doc(doc.id)
                    .collection('doctorPatients')
                    .doc(_auth.currentUser!.uid)
                    .update(
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
                    'diabetes': diabetes,
                    'hypertension': hypertension,
                    'hypotension': hypotension,
                    'tachycardia': tachycardia,
                    'bradycardia': bradycardia,
                    'cvd': cvd,
                  },
                );
              })
            }
        });
  }

  Future updateDoctorData(
      String adr, firstName, lastName, fax, tele, province, quali) async {
    /* used in doctor profile edit page to update their data in Firestore once they
    press confirm
     */
    await doctorProfileCollection.doc(_auth.currentUser!.uid).update(
      {
        'clinicAddress': adr,
        'fax': fax,
        'first name': firstName,
        'last name': lastName,
        'province': province,
        'quali': quali,
        'tele': tele,
      },
    );
    doctorPatientsCollection.get().then((docSnapshot) => {
          //if the doctor has a patient, update their patient(s)'s patientDoctors form
          if (docSnapshot.size > 0)
            {
              docSnapshot.docs.forEach((DocumentSnapshot doc) {
                patientProfileCollection
                    .doc(doc.id)
                    .collection('patientDoctors')
                    .doc(_auth.currentUser!.uid)
                    .set(
                  {
                    'doctorFirstName': firstName,
                    'doctorLastName': lastName,
                  },
                );
              })
            }
        });
  }

  Future dataDelete(String subcollection, int field) async {
    //deletes all data documents in the specified subcollection of a patient's data
    //if field is 0 the field will be updated
    await patientDataCollection
        .doc(_auth.currentUser!.uid)
        .collection(subcollection)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        patientDataCollection
            .doc(_auth.currentUser!.uid)
            .collection(subcollection)
            .doc(doc.id)
            .delete();
      });
    });
    if (field == 0) {
      patientDataCollection.doc(_auth.currentUser!.uid).set({
        'Average Blood Glucose (mg|dL)': '',
        'Average Blood Glucose (mmol|L)': '',
        'Average Blood Pressure (diastolic)': '',
        'Average Blood Pressure (systolic)': '',
        'Average Heart Rate': '',
        "bloodPressure readings (hundreds)": 0,
        "bloodGlucose readings (hundreds)": 0,
        "heartRate readings (hundreds)": 0,
      });
    }
  }

  Future erasePatientDocument() async {
    /* used in the delete my account function to delete document associated with
    patient's uid
     */
    await patientDoctorsCollection.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        //iterate through all the patient's doctors, in case patients have several docotrs
        doctorProfileCollection
            .doc(doc
                .id) //find the current patient from doctorPatients in the patientProfile Collection
            .collection('doctorPatients')
            .doc(_auth.currentUser!
                .uid) //find the doctor in this patient's patientDoctors collection
            .delete(); //delete the patient's document from the doctor's doctorPatients collection
      });
    });
    await patientProfileCollection.doc(_auth.currentUser!.uid).delete();
    await patientDataCollection.doc(_auth.currentUser!.uid).delete();
  }

  Future eraseDoctorDocument() async {
    /* used in the delete my account function to delete document associated with
    doctor's uid
     */
    await doctorPatientsCollection.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        //iterate through all the doctor's patients
        patientProfileCollection
            .doc(doc
                .id) //find the current patient from doctorPatients in the patientProfile Collection
            .collection('patientDoctors')
            .doc(_auth.currentUser!
                .uid) //find the doctor in this patient's patientDoctors collection
            .delete(); //delete the doctor's document from the patient's patientDoctors collection
      });
    });
    await doctorProfileCollection
        .doc(_auth.currentUser!.uid)
        .delete(); //delete the doctor from the doctorProfile collection
  }

  initializeData() {}
}

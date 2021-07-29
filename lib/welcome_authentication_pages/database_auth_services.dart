import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return await patientProfileCollection.doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'account type': accountType
    });
  }

  Future setDoctorData(String firstName, String lastName, String email,
      String accountType) async {
    return await doctorProfileCollection.doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'account type': accountType
    });
  }

  Future setDoctorCode(String physicianCode) async {
    return await doctorProfileCollection
        .doc(uid)
        .update({'access code': physicianCode});
  }

  Future deletePatientData() {
    return patientProfileCollection.doc(uid).delete();
  }

  Future deleteDoctorData() {
    return doctorProfileCollection.doc(uid).delete();
  }

  Future deletePatientUser(String email, String password) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      var result = await user!.reauthenticateWithCredential(credentials);
      await deletePatientData();
      await result.user!.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteDoctorUser(String email, String password) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      var result = await user!.reauthenticateWithCredential(credentials);
      await deleteDoctorData();
      await result.user!.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //stream
  Stream<QuerySnapshot> get patient {
    return patientProfileCollection.snapshots();
  }

  Future updatePatientData(String firstName, lastName, age, dob, sex, ht, wt, conds, meds, tele, adr) async {
    return await patientProfileCollection.doc(uid).update({
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
    },);
  }

}

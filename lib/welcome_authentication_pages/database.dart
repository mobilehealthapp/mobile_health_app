import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/User.dart';

class Database {
  var uid;

  Database({this.uid});

  final CollectionReference patientProfileCollection =
      FirebaseFirestore.instance.collection('patientprofile');

  final CollectionReference doctorProfileCollection =
      FirebaseFirestore.instance.collection('doctorprofile');

  // final CollectionReference patientProfileCollection =
  //     FirebaseFirestore.instance.collection('patientInfo');

  // // july 15
  //
  //
  //
  List<UserAddress>? _userListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserAddress(address: doc.get('address'));
    }).toList();
  }

  Stream<List<UserAddress>?> get users {
    return patientProfileCollection.snapshots().map(_userListFromSnapshots);
  }

  // Future getCurrentUserData() async {
  //   try {
  //     DocumentSnapshot ds = await patientProfileCollection.doc(uid).get();
  //     String address = ds.get('address');
  //     String age = ds.get('age');
  //     return [address, age];
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
  // //

  Future updatePatientInfo(
      String gender,
      String age,
      String dob,
      String meds,
      String conds,
      String wt,
      String ht,
      String tele,
      String email,
      String adr) async {
    return await patientProfileCollection.doc(uid).set(
      {
        'gender': gender,
        'age:': age,
        'date of birth ': dob,
        'medecins:': meds,
        'conditions: ': conds,
        'weight: ': wt,
        'height': ht,
        'telephone': tele,
        'email': email,
        'address: ': adr,
      },
    );
  }

  Future updatePatientData(String firstName, String lastName, String email,
      String accountType) async {
    return await patientProfileCollection.doc(uid).set(
      {
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'account type': accountType
      },
    );
  }

  Future updateDoctorData(String firstName, String lastName, String email,
      String accountType) async {
    return await doctorProfileCollection.doc(uid).set(
      {
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'account type': accountType
      },
    );
  }
}

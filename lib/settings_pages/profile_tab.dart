import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';
import 'profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class Patient {
//   late String first;
//   late String last;
//   late String age;
//   late String dob;
//   late String meds;
//   late String conds;
//   late String ht;
//   late String wt;
//   late String tele;
//   late String adr;
//
//   Patient.fromMap(Map<String, dynamic> data) {
//     first = data['first name'];
//     last = data['last name'];
//     age = data['age'];
//     dob = data['dob'];
//     meds = data['meds'];
//     conds = data['conds'];
//     ht = data['ht'];
//     wt = data['wt'];
//     tele = data['tele'];
//     adr = data['address'];
//   }
// }

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      body: SizedBox(
        height: 700.0,
        // child: StreamBuilder<QuerySnapshot>(
        //     // stream: _firestore.collection('patientprofile').snapshots(),
        //     // builder: (context, snapshot) {
        //     //   if (snapshot.hasData) {
        //     //     var doc = snapshot.data!.docs;
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            ProfileTab(
              editAnswer:
                  '${getPatientInfo('first name')} ${getPatientInfo('last name')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('age')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('dob')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('sex')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('ht')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('wt')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('conds')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('meds')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('tele')}',
            ),
            ProfileTab(
              editAnswer: '${getPatientInfo('address')}',
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEdit(),
                  ),
                ).then(
                  (value) => ProfileEdit.updateProfile(),
                );
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Edit my information'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser)!.uid;
  }

  var collection = FirebaseFirestore.instance.collection('patientprofile');

  getPatientInfo(String field) {
    collection
        .doc(getCurrentUID().toString())
        .snapshots()
        .listen((docSnapshot) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();

        var value = data?[field];
      }
    });
  }
}

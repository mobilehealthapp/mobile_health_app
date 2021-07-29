import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'settings_constants.dart';

import 'settings_card.dart';

final _firestore = FirebaseFirestore.instance;
var loggedInUser;
var uid;

class MyDoctors extends StatefulWidget {
  @override
  _MyDoctorsState createState() => _MyDoctorsState();
}

class _MyDoctorsState extends State<MyDoctors> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString(); //convert to string in this method
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text(
          'My Doctors',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColour,
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.pushNamed(context, '/addDoctors');
                  },
                );
              },
              child: TabContent(label: 'Add a doctor'),
              style: kSettingsCardStyle,
            ),
          ),
          DoctorList(),
        ],
      ),
    );
  }
}

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('patientprofile')
          .doc(uid)
          .collection('patientDoctors')
          .snapshots(),
      builder: (context, snapshot) {
        final doctors = snapshot.data!.docs;
        List<DoctorCard> doctorCardList = [];
        for (var doctor in doctors) {
          final firstName = doctor.get('doctorFirstName');
          final lastName = doctor.get('doctorLastName');
          final email = doctor.get('doctorEmail');
          final label = doctor.get('doctorLabel');

          final doctorCard = DoctorCard(
            firstName: firstName,
            lastName: lastName,
            email: email,
            label: label,
          );
          doctorCardList.add(doctorCard);
        }
        return ListView(
          key: UniqueKey(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: doctorCardList,
        );
      },
    );
  }
}

class DoctorCard extends StatelessWidget {
  final firstName;
  final lastName;
  final email;
  final label; //Card which will display information of doctor once patient adds one
  const DoctorCard({this.firstName, this.lastName, this.email, this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Text(
              '$label',
              style: kLabelStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$firstName $lastName',
                    style: kLabelStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qualifications',
                    style: kLabelStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Text(
              '$email',
              style: kLabelStyle,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

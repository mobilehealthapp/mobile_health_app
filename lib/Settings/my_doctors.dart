import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Settings/my_doctor_profile.dart';

import 'my_doctor_profile.dart';
import 'settings_card.dart';
import 'settings_constants.dart';

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
        title: Text('My Doctors'),
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
        try {
          for (var doctor in doctors) {
            final firstName = doctor.get('doctorFirstName');
            final lastName = doctor.get('doctorLastName');
            final email = doctor.get('doctorEmail');
            final label = doctor.get('doctorLabel');
            final docUID = doctor.get('doctorUID');
            final doctorCard = DoctorCard(
              firstName: firstName,
              lastName: lastName,
              email: email,
              label: label,
              docUID: docUID,
            );
            doctorCardList.add(doctorCard);
          }
        } catch (e) {
          print(e);
        }
        return ListView(
          key: UniqueKey(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: doctorCardList,
          physics: ClampingScrollPhysics(),
        );
      },
    );
  }
}

class DoctorCard extends StatelessWidget {
  final firstName;
  final lastName;
  final email;
  final label;
  final docUID; //Card which will display information of doctor once patient adds one
  const DoctorCard(
      {this.firstName, this.lastName, this.email, this.label, this.docUID});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      margin: EdgeInsets.all(10.0),
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Expanded(
                    child: Text(
                      '$label',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kLabelStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Expanded(
                    child: Text(
                      '$firstName $lastName',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kLabelStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Expanded(
                    child: Text(
                      '$email',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kLabelStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  var doctorInfo = await FirebaseFirestore.instance
                      .collection('doctorprofile')
                      .doc(docUID)
                      .get();
                  var drTele = await doctorInfo.get('tele');
                  var quali = await doctorInfo.get('quali');
                  var fax = await doctorInfo.get('fax');
                  var clinicAdr = await doctorInfo.get('clinicAddress');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyDoctorProfile(
                        drFirst: firstName,
                        drLast: lastName,
                        label: label,
                        fax: fax,
                        quali: quali,
                        drTele: drTele,
                        clinicAdr: clinicAdr,
                        email: email,
                      ),
                    ),
                  );
                },
                child: Text(
                  'View Profile',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  await _firestore
                                      .collection('patientprofile')
                                      .doc(uid)
                                      .collection('patientDoctors')
                                      .doc(docUID)
                                      .delete();
                                  await _firestore
                                      .collection('doctorprofile')
                                      .doc(docUID)
                                      .collection('doctorPatients')
                                      .doc(uid)
                                      .delete();
                                  Navigator.pop(context);
                                },
                                child: Text('Confirm'))
                          ],
                          title: Text('Remove Doctor'),
                          content: Text(
                              'Are you sure you want to remove $firstName $lastName from your list of doctors? This means they will no longer be able to access your patient data.'),
                        );
                      });
                },
                child: Text(
                  'Remove',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

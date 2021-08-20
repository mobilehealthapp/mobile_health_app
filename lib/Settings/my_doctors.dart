import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Settings/my_doctor_profile.dart';

import 'settings_classes.dart';
import 'settings_constants.dart';
//This file contains the UI and functionality for displaying a patient's list of approved doctors, which they can add through the 'Add a doctor' screen

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
    //Gets current user from FirebaseAuth and stores uid as variable for later use
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        uid = user.uid.toString(); //convert UID to string in this method
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
                    Navigator.pushNamed(context,
                        '/addDoctors'); //Navigates user to add doctor screen
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
          .snapshots(), //stream gathers snapshot of patient's doctors
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //checks if snapshot has data (will not have data if patient has not added a doctor)
          final doctors =
              snapshot.data!.docs; //compiles snapshot into list of documents
          List<DoctorCard> doctorCardList =
              []; //initializes list of doctor cards
          try {
            for (var doctor in doctors) {
              //iterates through each document in snapshot and collects information necessary to build doctor cards
              final firstName = doctor.get('doctorFirstName');
              final lastName = doctor.get('doctorLastName');
              final email = doctor.get('doctorEmail');
              final label = doctor.get('doctorLabel');
              final docUID = doctor.get('doctorUID');
              final doctorCard = DoctorCard(
                //creates a doctor card for each document in snapshot with obtained information
                firstName: firstName,
                lastName: lastName,
                email: email,
                label: label,
                docUID: docUID,
              );
              doctorCardList
                  .add(doctorCard); //adds doctor card to list of doctorcardlist
            }
          } catch (e) {
            print(e);
          }
          return ListView(
            //Streambuilder returns listview containing list of doctor cards
            key: UniqueKey(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: doctorCardList,
            physics: ClampingScrollPhysics(),
          );
        } else {
          return SizedBox
              .shrink(); //If snapshot has no data, returns an empty box (blank page with 'add doctor' button at the top
        }
      },
    );
  }
}

class DoctorCard extends StatelessWidget {
  //TODO: Improve styling/UI of doctor cards
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
                //'View profile' button that collects doctor's information from firebase and displays it on MyDoctorProfile page
                onPressed: () async {
                  var doctorInfo = await FirebaseFirestore.instance
                      .collection('doctorprofile')
                      .doc(docUID)
                      .get(); //Collects snapshot of document containing information of this doctor
                  var drTele = await doctorInfo.get('tele');
                  var quali = await doctorInfo.get('quali');
                  var fax = await doctorInfo.get('fax');
                  var clinicAdr = await doctorInfo
                      .get('clinicAddress'); //Stores specific data as variables
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
                        email:
                            email, //Passes variables from doctor card and firebase to MyDoctorProfile, navigates to doctor profile screen
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
                //Remove doctor button
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          //Displays alert asking for confirmation of removal of doctor from list
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context); //Closes alert and cancels removal
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  await _firestore
                                      .collection('patientprofile')
                                      .doc(uid)
                                      .collection('patientDoctors')
                                      .doc(docUID)
                                      .delete(); //Deletes doctor from patient profile
                                  await _firestore
                                      .collection('doctorprofile')
                                      .doc(docUID)
                                      .collection('doctorPatients')
                                      .doc(uid)
                                      .delete(); //Deletes patient from corresponding doctor profile
                                  Navigator.pop(context); //Closes alert
                                },
                                child: Text('Confirm'))
                          ],
                          title: Text('Remove Doctor'),
                          content: Text(
                              'Are you sure you want to remove $firstName $lastName from your list of doctors? This means they will no longer be able to access your data.'),
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

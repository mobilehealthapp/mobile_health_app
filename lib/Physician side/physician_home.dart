import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/physician_drawer.dart';
import 'package:mobile_health_app/Physician%20side/patient_data.dart';

//This file contains UI and functionality for the Physician home page, which displays a searchable list of a doctor's patients
var loggedInUser;
var uid;

class PhysHome extends StatefulWidget {
  @override
  _PhysHomeState createState() => _PhysHomeState();
}

class _PhysHomeState extends State<PhysHome> {
  List _allResults = [];
  List _resultsList = [];
  var resultsloaded;
  TextEditingController _searchcontroller =
      TextEditingController(); //TextEditingController allows for control over textfield

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser(); //Method to obtain current user data
    _searchcontroller.addListener(
        onsearchchange); //Adds listener to search controller to update when text is entered
  }

  @override
  void dispose() {
    _searchcontroller.removeListener(onsearchchange());
    _searchcontroller.dispose(); //removes search controller when page is closed
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsloaded = getpatientsnapshots();
  }

  onsearchchange() {
    searchresults();
  } //Function performed when text is entered into textfield

  searchresults() {
    var showresults = []; //Empty list
    if (_searchcontroller.text != '') {
      //If text field is not empty
      for (var patientsnapshot in _allResults) {
        //iterates through patient snapshots
        var patientname = getpatientnames(patientsnapshot)
            .toString()
            .toLowerCase(); //saves patient name and converts to lowercase
        if (patientname.contains(_searchcontroller.text.toLowerCase())) {
          //checks if patient name contains text from textfield
          showresults
              .add(patientsnapshot); //adds patient to list of visible results
        }
      }
    } else {
      showresults = List.from(
          _allResults); //if text field is empty, displays all patients
    }
    setState(() {
      _resultsList = showresults;
    });
  }

  Future<void> getpatientsnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('doctorprofile')
        .doc(uid)
        .collection('doctorPatients')
        .get(); //Gets patient snapshots from Cloud Firestore
    setState(() {
      _allResults = data.docs; //Saves documents as a variable
    });
    searchresults();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
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
      drawer: PhysDrawers(),
      appBar: AppBar(
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => InputFile()));
        //     },
        //   )
        // ],
        title: Text('Physician Home Page'),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: TextField(
              //Search bar
              controller: _searchcontroller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Patient Name'),
              style: TextStyle(fontSize: 20),
            ),
          ),
          RefreshIndicator(
            //When listview is pulled down, list refreshes with updated patient data
            onRefresh: getpatientsnapshots,
            child: ListView.builder(
                //builds listview of patient cards based on inputted text
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return buildPatientCard(context, _resultsList[index]);
                },
                itemCount: _resultsList.length),
          ),
        ],
      ),
    );
  }

  getpatientnames(DocumentSnapshot snapshot) {
    //gets patient names for display
    String fullpatientname =
        '${snapshot['first name']} ${snapshot['last name']}';
    return fullpatientname;
  }
}

class PatientCard extends StatelessWidget {
  //TODO: Improve styling of patient card, add more information to be displayed
  PatientCard(
      {required this.name, required this.email, required this.patientUID}); //

  final String name;
  final String email;
  final String patientUID; //

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientData(
                        //Navigates to patient's graph of data
                        patientUID: patientUID,
                        patientName: name,
                      )));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        name,
                        style: kTextLabel1,
                      ),
                      Container(
                          child: ElevatedButton(
                        onPressed: () {},
                        child: Text(''),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ))
                    ]),
                SizedBox(
                  height: 10.0,
                ),
                // Text(
                //   email,
                //   style: kTextLabel2,
                // ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text("Average Blood Press : "),
                    Text(''),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildPatientCard(BuildContext context, DocumentSnapshot document) {
  //Builds patient card with name and email
  final name = '${document['first name']} ${document['last name']}';
  final email = document['email'];
  final patientUID = document['patientUID']; //

  return PatientCard(
    name: name,
    email: email,
    patientUID: patientUID, //
  );
}

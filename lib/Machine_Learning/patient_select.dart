import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Machine_Learning/predictive_graph.dart';
import '/config.dart' as config;
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
final uid = user!.uid;

class PatientSelect extends StatefulWidget {
  PatientSelect({Key? key, text}) : super(key: key);
  @override
  PatientSelectState createState() => PatientSelectState();
}

class PatientSelectState extends State<PatientSelect> {
  bool loaded =
      false; //loaded becomes true when the doctorPatients collection has been iterate through
  bool haspatients = true;
  String? chosenPatient; //patient chosen in dropdown bar
  int index = -1; //marks what index the current patient is in the list
  var patientList = ['']; //list of patient names
  var uidList = []; //list of uids

  final CollectionReference doctorPatientsCollection = FirebaseFirestore
      .instance
      .collection('doctorprofile')
      .doc(uid)
      .collection('doctorPatients');

  @override
  void initState() {
    super.initState();
    getPatientList();
  }

  getPatientList() async {
    int firstspot = 0;
    var list = [''];
    await doctorPatientsCollection.get().then((docSnapshot) => {
          //if the doctor has patients, put them in a list
          if (docSnapshot.size > 0)
            {
              docSnapshot.docs.forEach((DocumentSnapshot doc) {
                String first = doc.get('first name');
                String last = doc.get('last name');
                if (first == "" && last == "") {
                  return;
                }
                String full = ("$first $last");
                if (firstspot == 0) {
                  list[0] = full;
                  firstspot++;
                } else {
                  list.add(full);
                }
                String patientid = doc.get('patientUID');
                uidList.add(patientid);
              }),
            }
        });
    if (list == ['']) {
      haspatients = false;
    }
    loaded = true;
    patientList = list;
    setState(() {});
  }

  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (loaded && haspatients) {
      //if patients have been found and loaded display dropdownbar
      return Scaffold(
        drawer: PhysicianDrawers(),
        appBar: AppBar(
          title: Text("Patient Predictions"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  'Choose a Patient and Tap Proceed\n To see a User\'s predicted data',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text("Select a Patient"),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    isExpanded: true,
                    value: chosenPatient,
                    items: patientList.map(buildItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        index = patientList.indexOf(value!);
                        //print(index);
                        chosenPatient = value;
                      });
                    },
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Proceed',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                onPressed: () async {
                  if (index == -1) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                                title: Text('No Patient Selected',
                                    textAlign: TextAlign.center),
                                content: Text("Please Select a Patient",
                                    textAlign: TextAlign.center),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ]),
                        barrierDismissible:
                            true); //barrierDismissible allows the user to dismiss the popup by tapping outside
                  } else {
                    String patientid = uidList[index];
                    String name = patientList[index];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PredictiveGraph(
                                patientid: patientid, name: name)));
                    //navigate to predicted graph page with data
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else if (loaded && !haspatients) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Predicted Data"),
          centerTitle: true,
        ),
        body: Center(
          child: Text('No Patients Found'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Predicted Data"),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Loading Patients...'),
        ),
      );
    }
  }
}

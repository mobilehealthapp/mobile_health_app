import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Machine_Learning/predictive_graph.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
final uid = user!.uid;

class PatientInfo {
  ///Struct to hold the useful information about a patient to save from
  ///having multiple data lists.
  late final String first;
  late final String last;
  late final String uid;

  PatientInfo(this.first, this.last, this.uid);

  String get fullName => "$first $last";
}

class PatientSelect extends StatefulWidget {
  PatientSelect({Key? key, text}) : super(key: key);

  @override
  PatientSelectState createState() => PatientSelectState();
}

class PatientSelectState extends State<PatientSelect> {
  late Future<List<PatientInfo>?> futurePatientList;
  String? chosenPatient;

  final CollectionReference doctorPatientsCollection = FirebaseFirestore
      .instance
      .collection('doctorprofile')
      .doc(uid)
      .collection('doctorPatients');


  @override
  void initState() {
    super.initState();
    futurePatientList = fetchPatientList();
  }


  Future<List<PatientInfo>?> fetchPatientList() async {
    ///Use [doctorPatientsCollection] to get all of a doctors patients.
    ///Returns a list of PatientInfo, or null if there are no patients.
    List<PatientInfo> patientsInfo = [];

    await doctorPatientsCollection.get().then((docSnapshot) {
      if (docSnapshot.size == 0) {
        return null;
      }

      docSnapshot.docs.forEach((DocumentSnapshot doc) {
        String first = doc.get('first name');
        String last = doc.get('last name');
        String uid = doc.get('patientUID');
        if (!(first == "") || !(last == "")) {
          patientsInfo.add(PatientInfo(first, last, uid));
        }
      });
    });
    return patientsInfo;
  }


  FutureBuilder<List<PatientInfo>?> patientListFutureBuilder({
    required Function whileWaiting,
    required Function ifEmpty,
    required Function sAllGood,
  })
  ///Builds a future builder to wait for and process [futurePatientList].
  /// [whileWaiting], [ifEmpty] and [sAllGood] are the functions
  /// that are executed, depending on the resultant state of [future]
  {
    return FutureBuilder<List<PatientInfo>?>(
        future: futurePatientList,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<PatientInfo>?> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return sAllGood(snapshot.data);
            } else {
              return ifEmpty();
            }
          } else {
            // This should really be:
            // else/if ConectionState==ConectionState.waiting
            // But the IDE didn't like the possibility of paths not returning
            return whileWaiting();
          }
        });
  }


  DropdownMenuItem<String> buildDropEntry(String item) {
    ///Builds a single drop down entry, with [item] as it's text.
    return DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));
  }


  Container buildDropDown(List<String> patientNames) {
    ///Creates a dropdown menu to select from given [patientNames].
    return Container(
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
            items: patientNames.map(buildDropEntry).toList(),
            onChanged: (value) {
              setState(() {
                chosenPatient = value;
              });
            }),
      ),
    );
  }


  void goToPredictiveGraph(name, uid) {
    ///Generates and pushes a path to a PredictiveGraph.
    ///Graph made from given params of patient's [name] and [uid]
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PredictiveGraph(name: name, patientid: uid)));
  }


  void showNoPatientSelectedDialog(){
    ///Handles the event where no patient is selected but the button is pressed
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text('No Patient Selected',
                textAlign: TextAlign.center),
            content: Text("Please Select a Patient",
                textAlign: TextAlign.center),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () { Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ]),
        barrierDismissible: true);
  }


  TextButton buildProceedButton(patients, patientNames) {
    ///Build the button that let's the user use their selected patient
    ///for the predictive graph.
    ///Also calls the function to handle when no patient is selected and the button is pressed
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.green),
      child:
          Text('Proceed', style: TextStyle(fontSize: 24, color: Colors.white)),
      onPressed: () {
        int index = patientNames.indexOf(chosenPatient!);
        if (index == -1) {
          showNoPatientSelectedDialog();
        } else {
          goToPredictiveGraph(patients[index].fullName, patients[index].uid);
        }
      },
    );
  }


  Text mainMessageOnPage(){
    ///Creates the primary message on the page instructing the user on what to do.
    return Text(
        "Choose a Patient and Tap Proceed\n To see a User's predicted data",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
    );
  }


  Text whileWaitingForPatients() => Text('Loading Patients...');


  Text ifPatientsIsEmpty() => Text('No Patients Found');


  Widget patientsReturned(List<PatientInfo> patients) {
    ///Function for handling the futurePatientList returning as expected.
    List<String> patientNames = patients.map((p) => p.fullName).toList();
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        mainMessageOnPage(),
        buildDropDown(patientNames),
        buildProceedButton(patients, patientNames),
      ],
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PhysicianDrawers(),
      appBar: AppBar(title: Text('Patient Predictions'), centerTitle: true),
      body: patientListFutureBuilder(
          whileWaiting: whileWaitingForPatients,
          ifEmpty: ifPatientsIsEmpty,
          sAllGood: patientsReturned),
    );
  }
}

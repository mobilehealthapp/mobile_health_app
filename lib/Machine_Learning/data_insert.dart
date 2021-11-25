import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

class DataInsert extends StatefulWidget {
  DataInsert({Key? key, text}) : super(key: key);
  @override
  DataInsertState createState() => DataInsertState();
}

final CollectionReference patientProfileCollection =
    FirebaseFirestore.instance.collection('patientprofile');

final CollectionReference patientDataCollection =
    FirebaseFirestore.instance.collection('patientData');
final patientData = FirebaseFirestore.instance.collection('patientData');
var userData;
var _auth = FirebaseAuth.instance;
var loggedInUser;
var user = _auth.currentUser;
var uid = user!.uid.toString();

class DataInsertState extends State<DataInsert> {
//allow camera-less data insertion here using methods created in data_transfer.dart
  String date = "";
  num measurement1 = 0;
  num measurement2 = 0;
  String subcol = "";
  var uploadlist;

  initState() {
    super.initState();
    userData = patientData.doc(uid);
    date = DateTime.now().toUtc().toString();
  }

  Future<void> dataInsert(String subcollection, final date, num measurement1,
      num? measurement2) async {
    num measurements = 0;
    bool noentries = false;
    bool lastentry = false;
    DocumentSnapshot snapshot = await userData
        .collection(subcollection)
        .doc("Last 100 Recordings")
        .get();
    if (snapshot.exists) {
      // if the user has data entries check how many there are
      num entries = snapshot.get('Data Entries');
      if (entries == 99) {
        await adjustData(subcollection, snapshot.data());
        noentries = true;
      } else {
        if (entries == 98) {
          lastentry = true;
        }
        measurements =
            entries; //for measurements, the greater the measurement the longer ago it was taken
      }
    } else {
      noentries = true;
    }
    measurements++;
    String insertion;
    if (measurements < 10) {
      insertion =
          "Data Submission 0$measurements"; //helps with layout inside database
    } else {
      insertion = "Data Submission $measurements";
    }
    String data;
    if (measurement2 != null) {
      //puts the data and date into a parsable String
      data = "$measurement1,$measurement2,-$date";
    } else {
      data = "$measurement1,-$date";
    }
    // Creates a document under patientData/$uid/subcollection/
    // that holds the last 100 data entries
    if (noentries) {
      //if user has no data Entries in their last 100 put this as the oldest date
      userData.collection(subcollection).doc("Last 100 Recordings").set({
        'Oldest Date': date,
        'Data Entries': measurements,
        insertion: data,
      });
    } else if (lastentry) {
      //if this is the last entry of this document include it's date
      userData.collection(subcollection).doc("Last 100 Recordings").update({
        'Most Recent Date': date,
        'Data Entries': measurements,
        insertion: data,
      });
    } else {
      userData.collection(subcollection).doc("Last 100 Recordings").update({
        'Data Entries': measurements,
        insertion: data,
      });
    }
  }

  Future<void> adjustData(String subcollection, Object? data) async {
    //creates the document for the next one hundred values
    var subcol = userData.collection(subcollection);
    num newspot = 0;
    DocumentSnapshot snapshot = await userData.get();
    if (snapshot.exists) {
      if (snapshot.get("$subcollection Recordings (hundreds)") > 0) {
        newspot = snapshot.get("$subcollection Recordings (hundreds)");
        print(newspot);
      }
    }
    num bottom = newspot * 100;
    num top = (newspot + 1) * 100;
    newspot++; //increment newspot to update the hundreds readings count for this subcollection
    String newdoc = bottom.toString() + "~" + top.toString() + " Recordings";
    subcol.doc(newdoc).set(data);
    // saves the last 100 measurements to a new document
    // deletes the old document
    subcol.doc("Last 100 Recordings").delete();
    userData.update(
      {
        "$subcollection Recordings (hundreds)":
            newspot, //update document readings (hundreds)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: Text("Data Insertion"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (text) {
              subcol = text;
            },
            decoration: InputDecoration(
              hintText: 'Enter Subcollection Type (MANDATORY)',
            ),
          ),
          TextField(
            onChanged: (text) {
              measurement1 = num.parse(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter First Value',
            ),
          ),
          TextField(
            onChanged: (text) {
              measurement2 = num.parse(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter Second Value',
            ),
          ),
          TextButton(
            onPressed: () async {
              print(measurement1);
              print(measurement2);
              if (measurement2 == 0) {
                dataInsert(subcol, date, measurement1, null);
              } else {
                dataInsert(subcol, date, measurement1, measurement2);
              }
            },
            child: Text('Send Values'),
          ),
          TextButton(
            onPressed: () async {
              await pickFile();
              print(uploadlist.length);
              for (int i = 0; i < uploadlist.length; i++) {
                await dataInsert(subcol, uploadlist[i + 2], uploadlist[i],
                    uploadlist[i + 1]);
                i = i + 2;
              }
            },
            child: Text('Choose CSV File'),
          ),
        ],
      ),
    );
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      //14229460
      print(file.path!);
      String filepath = file.path!;
      createList(filepath);
    }
  }

  Future createList(String filepath) async {
    var list = [];
    final lines = File(filepath).readAsLinesSync(); //it can't find the file...
    lines.removeAt(0);
    double glucoseConversion = 18.0182;
    //MG,MMOL,-date time is the order we want to put it in
    int i = 1;
    for (var line in lines) {
      String dateandtime = line.split(',')[0];
      double mg =
          double.parse(double.parse(line.split(',')[1]).toStringAsFixed(2));
      double mmol = double.parse(
          (double.parse(line.split(',')[1]) / glucoseConversion)
              .toStringAsFixed(2));
      list.add(mg);
      list.add(mmol);
      list.add(dateandtime);
      print('$mg,$mmol,-$dateandtime');
      i++;
      if (i > 3361) {
        break;
      }
    }
    uploadlist = list;
  }
}

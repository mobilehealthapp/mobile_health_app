import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/camera/data_transfer.dart';

class DataInsert extends StatefulWidget {
  DataInsert({Key? key, text}) : super(key: key);
  @override
  DataInsertState createState() => DataInsertState();
}

class DataInsertState extends State<DataInsert> {
//allow camera-less data insertion here using methods created in data_transfer.dart
  String date = "";
  num measurement1 = 0;
  num measurement2 = 0;
  String subcol = "";

  initState() {
    super.initState();
    date = DateTime.now().toUtc().toString();
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
              hintText: 'Enter Subcollection Type',
            ),
          ),
          TextField(
            onChanged: (text) {
              measurement1 = int.parse(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter First Value',
            ),
          ),
          TextField(
            onChanged: (text) {
              measurement2 = int.parse(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter Second Value',
            ),
          ),
          TextButton(
            onPressed: () {
              Data(null,2, 3).dataInsert(subcol, date, measurement1, measurement2);
            },
            child: Text('Send Values'),
          ),
        ],
      ),
    );
  }
}

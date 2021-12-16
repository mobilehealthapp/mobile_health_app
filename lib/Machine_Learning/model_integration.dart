import 'dart:async';
import 'dart:io';
import 'package:calc/calc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
final uid = user!.uid;


class MachineLearning extends StatefulWidget {
  const MachineLearning({Key? key}) : super(key: key);

  @override
  _MachineLearningState createState() => _MachineLearningState();
}

class _MachineLearningState extends State<MachineLearning> {

  late FirebaseCustomModel model;
  late Interpreter interpreter;
  late var inputs;
  late var outputs;
  late var actualOutputs;

  final DocumentReference<Map> inputsRef = FirebaseFirestore
      .instance
      .collection('ML_Test')
      .doc('six_in');

  final DocumentReference<Map> outputsRef = FirebaseFirestore
      .instance
      .collection('ML_Test')
      .doc('six_out');

  @override
  void initState() {

    super.initState();
  }

  Future callDatabase() async {
    Map tempInputs;
    inputsRef.get().then((value) => tempInputs = value.data()!);
    // tempInputs.keys.toList().sort((a,b)=>a.compareTo(b)).forEach((date)=> date);
    actualOutputs = await outputsRef.get();
  }

  Future fetchModel() async {
     model = await FirebaseModelDownloader.instance.getModel('bad_conv-encoder_lstm-decoder', FirebaseModelDownloadType.latestModel);
     interpreter = Interpreter.fromFile(model.file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawers(),
        appBar: AppBar(
            title: const Text('ML Scratch Pad'),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: callDatabase(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.connectionState == ConnectionState.done){
                  print('Data: ');
                  print(inputs.data());
                  print(actualOutputs.data());
                return Text('Loaded data');
            }
              return Text('Loading...');}),
          FutureBuilder(
            future: fetchModel(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.connectionState == ConnectionState.done){
                print(model.name);
                return Text(model.name);
              } else {
                return Text('Loading...');
              }
            }),
    ],
        ),
    );
  }
}

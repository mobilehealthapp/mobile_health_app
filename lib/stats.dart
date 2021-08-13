import 'package:flutter/material.dart';
import 'package:statistics/statistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

var patientData = FirebaseFirestore.instance
    .collection('patientData')
    .doc(FirebaseAuth.instance.currentUser!.uid);
var bloodGlucose = patientData.collection('bloodGlucose').get();
var bloodPressure = patientData.collection('bloodPressure').get();
var heartRate = patientData.collection('heartRate').get();

var varianceBG;
var standardDeviationBG;
var avgGlucose;
final List bg = [];

var varianceHR;
var standardDeviationHR;
var avgHR;
final List hr = [];

var variancePressureSys;
var standardDeviationSys;
var avgPressureSys;
final List sys = [];

var variancePressureDia;
var standardDeviationDia;
var avgPressureDia;
final List dia = [];

getAverages() async {
  final DocumentSnapshot uploadedData = await patientData.get();
  avgGlucose = uploadedData.get('Average Blood Glucose (mmol|L)');
  avgPressureDia = uploadedData.get('Average Blood Pressure (diastolic)');
  avgPressureSys = uploadedData.get('Average Blood Pressure (systolic)');
  avgHR = uploadedData.get('Average Heart Rate');
}

getBG() async {
  final bgData = await bloodGlucose;
  final value = bgData.docs;
  for (var val in value) {
    double bgGet = val.get('blood glucose (mmol|L)');
    bg.add(bgGet.toDouble());
  }
  return bg;
}

getHR() async {
  final hrData = await heartRate;
  final value = hrData.docs;
  for (var val in value) {
    int hrGet = val.get('heart rate');
    hr.add(hrGet.toDouble());
  }

  return hr;
}

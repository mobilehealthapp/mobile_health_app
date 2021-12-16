import 'dart:async';
import 'dart:io';
import 'dart:math' show sin, cos, pi;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';

class BGDataVector{

  late DateTime time;
  late num bg;
  late num cgm;
  late num insulin;
  late num lbgi;
  late num hbgi;
  late num risk;
  late num meal;

  BGDataVector({
    required String time,
    required this.bg,
    num? cgm,
    required this.insulin,
    required this.lbgi,
    required this.hbgi,
    required this.risk,
    required this.meal,
  }){
    this.time = DateTime.parse(time);
    this.cgm = cgm ?? this.bg; //If there's no constant monitoring, set it to bg
  }

  BGDataVector.fromDict(Map data){

  }

  num get secondsSinceEpoch => this.time.millisecondsSinceEpoch/1000;

  num get timeCos => cos(this.secondsSinceEpoch * (2 * pi / (24 * 60 * 60)));

  num get timeSin=> sin(this.secondsSinceEpoch * (2 * pi / (24 * 60 * 60)));

  List get DataVector => [
    time, bg, cgm, insulin, lbgi,
    hbgi, risk, meal, timeCos, timeSin
  ];


}
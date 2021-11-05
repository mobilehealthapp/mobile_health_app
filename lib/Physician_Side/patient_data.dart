import 'package:calc/calc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Data/patient_data_functions.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Graphs/graph_data.dart';

import '/Graphs/graph_info.dart';

//This file is identical to the health analysis file on the patient side of the app, except several variables must be declared multiple times in various functions
//The purpose of this file is for doctors to view each patient's data
List<FlSpot> heartRateList = [];
List<FlSpot> diastolicList = [];
List<FlSpot> systolicList = [];
List<FlSpot> glucoseList = [];
late int numberOfBGPoints = 0;
late int numberOfBPPoints = 0;
late int numberOfHRPoints = 0;

var varianceBG;
var standardDeviationBG;
var avgGlucose;
List bg = [];

var varianceHR;
var standardDeviationHR;
var avgHeartRate;
List hr = [];

var variancePressureSys;
var standardDeviationSys;
var avgPressureSys;
List sys = [];

var variancePressureDia;
var standardDeviationDia;
var avgPressureDia;
List dia = [];

class PatientData extends StatefulWidget {
  final patientUID;
  final patientName;
  PatientData({this.patientUID, this.patientName});
  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  bool isBGFilled = true;
  bool isBPFilled = true;
  bool isHRFilled = true;
  var patientData;

  var bg = [];
  var bloodGlucose;
  int bgsize = 0;
  var bglist;

  var sys = [];
  var dia = [];
  var bloodPressure;
  int bpsize = 0;
  var bplist;

  var hr = [];
  var heartRate;
  int hrsize = 0;
  var hrlist;

  Datafunction datafunc = Datafunction('');

  bgGet() async {
    bgsize = await datafunc.getSize('bloodGlucose');
    int sizelimiter;
    if (bgsize > 100) {
      //if there are more than 100 recordings, only take the last 99
      sizelimiter = 99;
    } else {
      sizelimiter = bgsize;
    }
    numberOfBGPoints = sizelimiter;
    bglist = await datafunc.getAmount(sizelimiter, 'bloodGlucose');
    if (bglist != null) {
      for (int i = 0; i < bglist.length; i++) {
        String data = bglist[i];
        double bgGet = double.parse(data.split(',')[0]);
        bg.add(bgGet);
      }
      getBGData();
      avgGlucose = getAverage(bg);
    } else {
      return;
    }

    var doubles = bg.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation();
    setState(() {
      standardDeviationBG = sdv.toStringAsFixed(3);
      var sdv2 = sdv;
      varianceBG = sqrt(sdv2).toStringAsFixed(3);
    });
    bg.sort();
    return [standardDeviationBG, varianceBG, bg];
  }

  hrGet() async {
    hrsize = await datafunc.getSize('heartRate');
    int sizelimiter;
    if (hrsize > 100) {
      //if there are more than 100 recordings, only take the last 99
      sizelimiter = 99;
    } else {
      sizelimiter = hrsize;
    }
    numberOfHRPoints = sizelimiter;
    hrlist = await Datafunction(widget.patientUID)
        .getAmount(sizelimiter, 'heartRate');
    if (hrlist != null) {
      for (int i = 0; i < hrlist.length; i++) {
        String data = hrlist[i];
        int hrGet = int.parse(data.split(',')[0]);
        hr.add(hrGet);
      }
      avgHeartRate = getAverage(hr);
      getHRData();
    } else {
      return;
    }
    var ints = hr.map((e) => e as int).toList();

    final sdv = ints.standardDeviation().toInt();

    setState(() {
      standardDeviationHR = sdv.truncateToDouble();
      varianceHR = sqrt(standardDeviationHR).toStringAsFixed(3);
    });
    hr.sort();
    return [standardDeviationHR, varianceHR, hr];
  }

  sysGet() async {
    bpsize = await datafunc.getSize('bloodPressure');
    int sizelimiter;
    if (bpsize > 100) {
      //if there are more than 100 recordings, only take the last 99
      sizelimiter = 99;
    } else {
      sizelimiter = bpsize;
    }
    numberOfBPPoints = sizelimiter;
    bplist = await Datafunction(widget.patientUID)
        .getAmount(sizelimiter, 'bloodPressure');
    diaGet(); //call diaGet() through this method
    if (bplist != null) {
      for (int i = 0; i < bplist.length; i++) {
        String data = bplist[i];
        double sysGet = double.parse(data.split(',')[0]);
        sys.add(sysGet);
      }
      avgPressureSys = getAverage(sys);
      getSysData();
      getDiasData();
    } else {
      return;
    }
    sys.sort();

    var doubles = sys.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation().toDouble();

    setState(() {
      standardDeviationSys = sdv.truncateToDouble();
      variancePressureSys = sqrt(standardDeviationSys).toStringAsFixed(3);
    });
    sys.sort();
    return [standardDeviationSys, variancePressureSys, sys];
  }

  diaGet() {
    if (bplist != null) {
      for (int i = 0; i < bplist.length; i++) {
        String data = bplist[i];
        double diaGet = double.parse(data.split(',')[1]);
        dia.add(diaGet);
      }
      avgPressureDia = getAverage(dia);
    } else {
      return;
    }
    var doubles = dia.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation().toDouble();

    setState(() {
      standardDeviationDia = sdv.truncateToDouble();
      variancePressureDia = sqrt(standardDeviationDia).toStringAsFixed(3);
    });
    dia.sort();
    return [standardDeviationDia, variancePressureDia, dia];
  }

  int getAverage(var type) {
    //calculate the average of the list, type = bg || sys || dia || hr
    num average = 0;
    for (int i = 0; i < type.length; i++) {
      average += type[i];
    }
    return average ~/ type.length;
  }

  Future<List<FlSpot>> getHRData() async {
    // gets list of HR points to use in Graphs
    heartRateList = [];
    double index = 1.0;
    String data;
    double hr;
    if (hrlist == null) {
      return heartRateList;
    }
    for (int i = 0; i < hrlist.length; i++) {
      data = hrlist[i];
      hr = double.parse(hrlist[i].split(',')[0]);
      setState(() {
        heartRateList.add(FlSpot(index++, hr));
      });
    }
    return heartRateList;
  }

  hrFilledYN() {
    if (heartRateList == []) {
      isHRFilled = false;
    }
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of BP (diastolic) points to use in Graphs
    diastolicList = [];
    double index = 1.0;
    String data;
    double diast;
    if (bplist == null) {
      return diastolicList;
    }
    for (int i = 0; i < bplist.length; i++) {
      data = bplist[i];
      diast = double.parse(bplist[i].split(',')[1]);
      setState(() {
        diastolicList.add(FlSpot(index++, diast));
      });
    }
    return diastolicList;
  }

  Future<List<FlSpot>> getSysData() async {
    // gets list of BP (systolic) points to use in Graphs
    systolicList = [];
    double index2 = 1.0;
    String data;
    double syst;
    if (bplist == null) {
      return systolicList;
    }
    for (int i = 0; i < bplist.length; i++) {
      data = bplist[i];
      syst = double.parse(bplist[i].split(',')[0]);
      setState(() {
        systolicList.add(FlSpot(index2++, syst));
      });
    }
    return systolicList;
  }

  List<FlSpot> getBGData() {
    // gets list of BG points to use in Graphs
    glucoseList = [];
    double index = 1.0;
    String data;
    double bg;
    if (bglist == null) {
      return glucoseList;
    }
    for (int i = 0; i < bglist.length; i++) {
      data = bglist[i];
      bg = double.parse(bglist[i].split(',')[1]); //get mmol/L value
      setState(() {
        glucoseList.add(FlSpot(index++, bg));
      });
    }
    return glucoseList;
  }

  @override
  void initState() {
    datafunc = Datafunction(widget.patientUID);
    bgGet();
    hrGet();
    sysGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.patientName,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: diastolicList.isNotEmpty
                ? extractBP()
                : NoDataCard(
                    textBody:
                        'The patient hasnt uploaded any data for blood pressure'),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            child: glucoseList.isNotEmpty
                ? extractBG()
                : NoDataCard(
                    textBody:
                        'The patient hasnt uploaded any data for blood glucose'),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            child: heartRateList.isNotEmpty
                ? extractHR()
                : NoDataCard(
                    textBody:
                        'The patient hasnt uploaded any data for heart rate'),
          ),
        ],
      ),
    );
  }

  Widget extractHR() {
    // graph of HR data
    return Column(
      children: [
        Text(
          'Heart Rate',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        HealthCharts(
          graphType: HealthCharts.HR,
          unitOfMeasurement: 'BPM',
          minY: 30,
          showDots: false,
          maxY: 200,
          maxX: numberOfHRPoints.toDouble(),
          primaryDataList: heartRateList,
        ),
        FullSummaryCard(
          avgValue: '$avgHeartRate BPM',
          varValue: '$varianceHR BPM',
          sdValue: '  $standardDeviationHR BPM',
          range: 'range',
          // range: '${hr[0]} - ${hr[numberOfHRPoints - 1]}',
        ),
      ],
    );
  }

  Widget extractBP() {
    // graph of BP data
    return Column(
      children: [
        Text(
          'Blood Pressure',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        HealthCharts(
          graphType: HealthCharts.BP,
          unitOfMeasurement: 'mmHg',
          minY: 10,
          showDots: false,
          maxY: 180,
          maxX: numberOfBPPoints.toDouble(),
          primaryDataList: diastolicList,
          secondaryDataList: systolicList,
        ),
        FullSummaryCard(
          avgValue: '$avgPressureSys/$avgPressureDia mmHg',
          varValue: '$variancePressureSys/$variancePressureDia mmHg',
          sdValue: '$standardDeviationSys/$standardDeviationDia mmHg',
          range: 'range',
          // range: '${sys[0]}/${dia[0]} - ${sys[numberOfBPPoints -
          //     1]}/${dia[numberOfBPPoints - 1]}',
          //range: '${sys.first} - ${sys.last}/' '${dia.first} - ${dia.last}',
        ),
      ],
    );
  }

  Widget extractBG() {
    // graph of BG data
    return Column(children: [
      Text(
        'Blood Glucose',
        style: kGraphTitleTextStyle,
        textAlign: TextAlign.center,
      ),
      HealthCharts(
        graphType: HealthCharts.BG,
        unitOfMeasurement: 'mmol/L',
        minY: 0,
        showDots: false,
        maxY: 10,
        maxX: numberOfBGPoints.toDouble(),
        primaryDataList: glucoseList,
      ),
      FullSummaryCard(
        avgValue: '$avgGlucose mmol/L',
        varValue: '$varianceBG mmol/L',
        sdValue: '$standardDeviationBG mmol/L',
        range: 'range',
        // range: '${bg[0]} - ${bg[numberOfBGPoints - 1]}',
        //range: '${bg.first} - ${bg.last}',
      ),
    ]);
    // DoctorList()
  }
}

class NoDataCard extends StatelessWidget {
  // card to display when user has no data of certain (or all) type(s)
  final String textBody;

  NoDataCard({required this.textBody});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                textBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          margin: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Color(0xFF607D8B),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

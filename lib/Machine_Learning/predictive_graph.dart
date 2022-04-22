import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '/Drawers/drawers.dart';
import 'package:http/http.dart' as http;
import '/config.dart' as config;

final CollectionReference patientDataCollection =
    FirebaseFirestore.instance.collection('patientData');

class PredictiveGraph extends StatefulWidget {
  final String patientid;
  final String name;
  PredictiveGraph({Key? key, required this.patientid, required this.name})
      : super(key: key);

  @override
  PredictiveGraphState createState() => PredictiveGraphState();
}

class PredictiveGraphState extends State<PredictiveGraph> {
  String patientid = "";
  String name = "";
  String firstname = "";

  DocumentReference patientBPCollection =
      patientDataCollection.doc('initalize');
  DocumentReference patientBGCollection =
      patientDataCollection.doc('initalize'); //to be initalized in initState
  DocumentReference patientHRCollection =
      patientDataCollection.doc('initalize');

  DocumentReference patientBPPredictions =
      patientDataCollection.doc('initalize');
  DocumentReference patientBGPredictions =
      patientDataCollection.doc('initalize'); //to be initalized in initState
  DocumentReference patientHRPredictions =
      patientDataCollection.doc('initalize');

  var bgdata = <BloodGlucose>[];
  var bgpredict = 4; //days that can be predicted into the future accurately -1
  List<charts.Series<BloodGlucose, int>> bglist = [];

  var bpdata = <BloodPressure>[];
  var bppredict = 4; //days that can be predicted into the future accurately -1
  List<charts.Series<BloodPressure, int>> bplist = [];

  var hrdata = <HeartRate>[];
  var hrpredict = 4;
  List<charts.Series<HeartRate, int>> hrlist = [];

  Widget bgchart = Text("Loading...");
  Widget bpchart = Text("Loading...");
  Widget hrchart = Text("Loading...");

  @override
  void initState() {
    super.initState();
    patientid = widget.patientid;
    name = widget.name;
    firstname = name.split(" ")[0];
    initializeReferences();
  }

  Future<void> callHRAPI(patientid) async {
    //Calls the ML model API to send patient's UID and update their predictions in firebase
    var uid = patientid;
    var url = Uri.parse('${config.apiUrl}/predict_HR?uid=$uid');
    try {
      await http.get(url);
    } catch (exception) {
      print(exception);
      throw (exception);
    }
  }

  Future<void> callBGAPI(patientid) async {
    //Calls the ML model API to send patient's UID and update their predictions in firebase
    var uid = patientid;
    var url = Uri.parse('${config.apiUrl}/predict_BG?uid=$uid');
    try {
      await http.get(url);
    } catch (exception) {
      print(exception);
      throw (exception);
    }
  }

  Future<void> callBPAPI(patientid) async {
    //Calls the ML model API to send patient's UID and update their predictions in firebase
    var uid = patientid;
    var url = Uri.parse('${config.apiUrl}/predict_BP?uid=$uid');
    try {
      await http.get(url);
    } catch (exception) {
      print(exception);
      throw (exception);
    }
  }

  void initializeReferences() {
    //initialize BP, BG and HR references
    //print(patientid + name);
    patientBPCollection = patientDataCollection
        .doc(patientid)
        .collection('bloodPressure')
        .doc("Last 100 Recordings");
    patientBPPredictions = patientDataCollection
        .doc(patientid)
        .collection('bloodPressure')
        .doc("Predicted values");
    patientBGCollection = patientDataCollection
        .doc(patientid)
        .collection('bloodGlucose')
        .doc("Last 100 Recordings");
    patientBGPredictions = patientDataCollection
        .doc('patientid')
        .collection('bloodGlucose')
        .doc('Predicted values');
    patientHRCollection = patientDataCollection
        .doc(patientid)
        .collection('heartRate')
        .doc("Last 100 Recordings");
    patientHRPredictions = patientDataCollection
        .doc(patientid)
        .collection('heartRate')
        .doc("Predicted values");
    generateBGList();
    generateBPList();
    generateHRList();
  }

  dayAssembler(num value) {
    //returns a string according to the day for the day axis labels, assumes 1x daily recording
    //TODO implement different day assembler functions depending on frequency of data uploads for each variable
    int val = value.toInt();
    if (val < bgpredict - 1) {
      if (val == bgpredict - 2) {
        return ('1 Recording ago');
      }
      int recording = bgpredict - 1 - val;
      return ('$recording Recordings ago');
    } else if (val == bgpredict - 1) {
      return ('Latest Recording');
    } else {
      if (val == bgpredict) {
        return ('Next Recording');
      }
      int recording = val - bgpredict;
      return ('$recording Recordings out');
    }
  }

  void generateBGList() async {
    int day = 0;
    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num? value) {
      //give each tick on the x-axis a name from the dayAssembler function
      return dayAssembler(value!);
    });
    DocumentSnapshot docSnapshot = await patientBGCollection.get();
    if (docSnapshot.exists) {
      await callBGAPI(patientid);
      int docsize = docSnapshot.get("Data Entries").toInt();
      //if the patient has bg readings, than take the last documents, based off of how many days can be accurately predicted
      if (docsize < bgpredict && docsize > 0) {
        bgpredict = docsize;
      }
      if (docsize >= bgpredict) {
        for (int i = docsize - (bgpredict - 1); i < docsize + 1; i++) {
          //get last measurements of the last 100
          String bloodglucose;
          if (i < 10) {
            bloodglucose = docSnapshot.get("Data Submission 0$i");
          } else {
            bloodglucose = docSnapshot.get(
                "Data Submission $i"); //get the persons blood glucose for that day
          } //get the persons blood glucose for that day
          num bg = num.parse(
              bloodglucose.split(',')[0]); //get the mg/dl bg recording
          bgdata.add(new BloodGlucose(bg,
              day)); //create a bloodGlucose object for that day and append it to the bgdata list
          day++;
        }
        DocumentSnapshot predictSnapshot = await patientBGPredictions.get();
        if (predictSnapshot.exists) {
          int predictdocsize = predictSnapshot.get("Data Entries").toInt();
          String predictedbloodglucose;
          for (int i = 0; i < predictdocsize; i++) {
            predictedbloodglucose = predictSnapshot.get('Prediction ${i + 1}');
            num bg = num.parse(predictedbloodglucose);
            bgdata.add(new BloodGlucose(bg, day));
            day++;
          }
        }

        //now add the 5 'predicted values' to bgdata before adding bgata to bg list
        bglist.add(charts.Series<BloodGlucose, int>(
          //add bgdata list to bglist (bglist is the chart list)
          id: 'blood glucose',
          colorFn: (BloodGlucose bloodglucose, __) {
            //make the predicted values red
            if (bloodglucose.day >= bgpredict) {
              return charts.MaterialPalette.red.shadeDefault;
            } else {
              return charts.MaterialPalette.blue.shadeDefault;
            }
          },
          domainFn: (BloodGlucose bloodglucose, _) => bloodglucose.day,
          measureFn: (BloodGlucose bloodglucose, _) => bloodglucose.bg,
          data: bgdata,
        ));
        bgchart = charts.LineChart(bglist,
            defaultRenderer: new charts.LineRendererConfig(
                includePoints: true, stacked: true),
            animate: false,
            animationDuration: Duration(seconds: 2),
            domainAxis: charts.NumericAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                  labelRotation:
                      50), //rotates the labels on the x-axis so that they dont overlap eachother
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount: bgpredict *
                      2), //make x-axis have same amount of ticks for recorded and predicted days
              tickFormatterSpec: customTickFormatter,
            ),
            behaviors: [
              new charts.ChartTitle('Blood Glucose (mmol/L)',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
            ]);
      }
    } else {
      bgchart = Text('No Blood Glucose Data');
    }
    setState(() {
      //update bg chart when this function is called
    });
  }

  void generateBPList() async {
    int day = 0;
    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num? value) {
      //give each tick on the x-axis a name from the dayAssembler function
      return dayAssembler(value!);
    });
    DocumentSnapshot docSnapshot = await patientBPCollection.get();
    if (docSnapshot.exists) {
      await callBPAPI(patientid);
      int docsize = docSnapshot.get('Data Entries').toInt();
      //if the patient has bg readings, than take the last documents, based off of how many days can be accurrately predicted
      if (docsize < bppredict && docsize > 0) {
        bppredict = docsize;
      }
      if (docsize >= bppredict) {
        for (int i = docsize - (bppredict - 1); i < docsize + 1; i++) {
          //get last measurements of the last 100
          String bloodpressure;
          if (i < 10) {
            bloodpressure = docSnapshot.get("Data Submission 0$i");
          } else {
            bloodpressure = docSnapshot.get(
                "Data Submission $i"); //get the persons blood glucose for that day
          }
          num dia = num.parse(
              bloodpressure.split(',')[1]); //get the mg/dl bg recording
          num sys = num.parse(bloodpressure.split(',')[0]) - dia;
          bpdata.add(new BloodPressure(dia, sys,
              day)); //create a bloodGlucose object for that day and append it to the bgdata list
          day++;
        }
        DocumentSnapshot predictSnapshot = await patientBPPredictions.get();
        if (predictSnapshot.exists) {
          int predictdocsize = predictSnapshot.get("Data Entries").toInt();
          String predictedbloodpressure;
          for (int i = 0; i < predictdocsize; i++) {
            predictedbloodpressure = predictSnapshot.get('Prediction ${i + 1}');
            num dia = num.parse(predictedbloodpressure.split(',')[1]);
            num sys = num.parse(predictedbloodpressure.split(',')[0]) - dia;
            bpdata.add(new BloodPressure(dia, sys, day));
            day++;
          }
        }
        //now add the 5 'predicted values' to bpdata before adding bpdata to bplist
        bplist.add(charts.Series<BloodPressure, int>(
          //add bpdata list to bplist (bplist is the chart list)
          id: 'diastolic',
          colorFn: (BloodPressure bloodpressure, __) {
            //make the predicted values red
            if (bloodpressure.day >= bppredict) {
              return charts.MaterialPalette.red.shadeDefault;
            } else {
              return charts.MaterialPalette.green.shadeDefault;
            }
          },
          domainFn: (BloodPressure bloodpressure, _) => bloodpressure.day,
          measureFn: (BloodPressure bloodpressure, _) =>
              bloodpressure.dia, //do one line for diastolic
          data: bpdata,
        ));
        bplist.add(charts.Series<BloodPressure, int>(
          id: 'systolic',
          colorFn: (BloodPressure bloodpressure, __) {
            if (bloodpressure.day >= bppredict) {
              return charts.MaterialPalette.red.shadeDefault;
            } else {
              return charts.MaterialPalette.blue.shadeDefault;
            }
          },
          domainFn: (BloodPressure bloodpressure, _) => bloodpressure.day,
          measureFn: (BloodPressure bloodpressure, _) =>
              bloodpressure.sys, //do one line for systolic
          data: bpdata,
        ));
        bpchart = charts.LineChart(bplist,
            defaultRenderer: new charts.LineRendererConfig(
                includePoints: true, stacked: true),
            animate: false,
            animationDuration: Duration(seconds: 2),
            domainAxis: charts.NumericAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                  labelRotation:
                      50), //rotates the labels on the x-axis so that they dont overlap eachother
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount: bppredict *
                      2), //make x-axis have same amount of ticks for recorded and predicted days
              tickFormatterSpec: customTickFormatter,
            ),
            behaviors: [
              new charts.ChartTitle('Systolic/Diastolic (mmHg)',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
            ]);
      }
    } else {
      bpchart = Text('No Blood Pressure Data');
    }
    setState(() {
      //update bg chart when this function is called
    });
  }

  void generateHRList() async {
    int day = 0;
    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num? value) {
      //give each tick on the x-axis a name from the dayAssembler function
      return dayAssembler(value!);
    });
    DocumentSnapshot docSnapshot = await patientHRCollection.get();
    if (docSnapshot.exists) {
      await callBGAPI(patientid);
      int docsize = docSnapshot.get("Data Entries").toInt();
      //if the patient has hr readings, than take the last documents, based off of how many days can be accurately predicted
      if (docsize < hrpredict && docsize > 0) {
        hrpredict = docsize;
      }
      if (docsize >= hrpredict) {
        for (int i = docsize - (hrpredict - 1); i < docsize + 1; i++) {
          //get last measurements of the last 100
          String heartrate;
          if (i < 10) {
            heartrate = docSnapshot.get("Data Submission 0$i");
          } else {
            heartrate = docSnapshot.get(
                "Data Submission $i"); //get the persons heart rate for that day
          } //get the persons heart rate for that day
          num hr =
              num.parse(heartrate.split(',')[0]); //get the heartrate recording
          hrdata.add(new HeartRate(hr,
              day)); //create a heartRate object for that day and append it to the hrdata list
          day++;
        }
        DocumentSnapshot predictSnapshot = await patientHRPredictions.get();
        if (predictSnapshot.exists) {
          int predictdocsize = predictSnapshot.get("Data Entries").toInt();
          print(predictdocsize);
          String predictedheartrate;
          for (int i = 0; i < predictdocsize; i++) {
            int predictionnumber = i + 1;
            predictedheartrate =
                predictSnapshot.get('Prediction ${predictionnumber.toString().padLeft(2 , '0')}');
            num hr = num.parse(predictedheartrate);
            hrdata.add(new HeartRate(hr, day));
            day++;
          }
        }
        //now add the 5 'predicted values' to hrdata before adding hrata to hr list
        hrlist.add(charts.Series<HeartRate, int>(
          //add hrdata list to hrlist (hrlist is the chart list)
          id: 'heart rate',
          colorFn: (HeartRate heartrate, __) {
            //make the predicted values red
            if (heartrate.day >= hrpredict) {
              return charts.MaterialPalette.red.shadeDefault;
            } else {
              return charts.MaterialPalette.blue.shadeDefault;
            }
          },
          domainFn: (HeartRate heartrate, _) => heartrate.day,
          measureFn: (HeartRate heartrate, _) => heartrate.hr,
          data: hrdata,
        ));
        hrchart = charts.LineChart(hrlist,
            defaultRenderer: new charts.LineRendererConfig(
                includePoints: true, stacked: true),
            animate: false,
            animationDuration: Duration(seconds: 2),
            domainAxis: charts.NumericAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                  labelRotation:
                      50), //rotates the labels on the x-axis so that they dont overlap eachother
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount: hrpredict *
                      2), //make x-axis have same amount of ticks for recorded and predicted days
              tickFormatterSpec: customTickFormatter,
            ),
            behaviors: [
              new charts.ChartTitle('Heart Rate (bpm)',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
            ]);
      }
    } else {
      hrchart = Text('No Heart Rate Data');
    }
    setState(() {
      //update hr chart when this function is called
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Color(0xff1976d2),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.firstAid),
                ),
                Tab(icon: Icon(FontAwesomeIcons.briefcaseMedical)),
                Tab(icon: Icon(FontAwesomeIcons.heartbeat))
              ],
            ),
            title: Text('$firstname\'s Future Predictions',
                style: TextStyle(fontSize: 22)),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Measured(blue) and Predicted(red) Blood Glucose Levels',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: bgchart),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Measured(blue/green) and Predicted(red) Blood Pressure',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: bpchart),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Measured(blue) and Predicted(red) Heart Rate Levels',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: hrchart),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BloodGlucose {
  final int day;
  final num bg;

  BloodGlucose(this.bg, this.day);
}

class BloodPressure {
  final num dia;
  final num sys;
  final int day;

  BloodPressure(this.dia, this.sys, this.day);
}

class HeartRate {
  final int day;
  final num hr;

  HeartRate(
    this.hr,
    this.day,
  );
}

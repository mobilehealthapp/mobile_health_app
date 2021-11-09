import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '/Drawers/drawers.dart';

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

  var bgdata = <BloodGlucose>[];
  var bgpredict = 5; //days that can be predicted into the future accurately -1
  List<charts.Series<BloodGlucose, int>> bglist = [];

  var bpdata = <BloodPressure>[];
  var bppredict = 5; //days that can be predicted into the future accurately -1
  List<charts.Series<BloodPressure, int>> bplist = [];

  Widget bgchart = Text("Loading...");
  Widget bpchart = Text("Loading...");

  @override
  void initState() {
    super.initState();
    patientid = widget.patientid;
    name = widget.name;
    firstname = name.split(" ")[0];
    initializeReferences();
  }

  void initializeReferences() {
    //initialize BP and BG references
    //print(patientid + name);
    patientBPCollection = patientDataCollection
        .doc(patientid)
        .collection('bloodPressure')
        .doc("Last 100 Recordings");
    patientBGCollection = patientDataCollection
        .doc(patientid)
        .collection('bloodGlucose')
        .doc("Last 100 Recordings");
    generateBGList();
    generateBPList();
  }

  dayAssembler(num value) {
    //returns a string according to the day for the day axis labels, assumes 1x daily bg recording
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
      int docsize = docSnapshot.get("Data Entries").toInt();
      //if the patient has bg readings, than take the last documents, based off of how many days can be accurately predicted
      if (docsize < bgpredict && docsize > 0) {
        bgchart =
            Text('Patients needs more blood glucose values to predict data');
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
        //now add the 5 'predicted values' to bgdata before adding bgata to bg list
        bglist.add(charts.Series<BloodGlucose, int>(
          //add bgdata list to bglist (bglist is the chart list)
          id: 'blood glucose',
          colorFn: (BloodGlucose bloodglucose, __) {
            //make the predicted values red
            if (bloodglucose.day > bgpredict) {
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
      int docsize = docSnapshot.get('Data Entries').toInt();
      //if the patient has bg readings, than take the last documents, based off of how many days can be accurrately predicted
      if (docsize < bppredict && docsize > 0) {
        bpchart =
            Text('Patients needs more blood pressure values to predict data');
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
        //now add the 5 'predicted values' to bpdata before adding bpdata to bplist
        bplist.add(charts.Series<BloodPressure, int>(
          //add bpdata list to bplist (bplist is the chart list)
          id: 'diastolic',
          colorFn: (BloodPressure bloodpressure, __) {
            //make the predicted values red
            if (bloodpressure.day > bppredict) {
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
            if (bloodpressure.day > bppredict) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
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
                Tab(icon: Icon(FontAwesomeIcons.heartbeat)),
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
                              fontSize: 22.0, fontWeight: FontWeight.bold),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '/Drawers/drawers.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
final uid = user!.uid;

final CollectionReference patientDataCollection =
    FirebaseFirestore.instance.collection('patientData');

final CollectionReference patientBGCollection =
    patientDataCollection.doc(uid).collection('bloodGlucose');

final CollectionReference patientBPCollection =
    patientDataCollection.doc(uid).collection('bloodPressure');

class PredictiveGraph extends StatefulWidget {
  PredictiveGraph({Key? key}) : super(key: key);
  @override
  PredictiveGraphState createState() => PredictiveGraphState();
}

class PredictiveGraphState extends State<PredictiveGraph> {
  var bgdata = <BloodGlucose>[];
  var bgpredict = 4; //days that can be predicted into the future accurately -1
  List<charts.Series<BloodGlucose, int>> bglist = [];

  var bpdata = <BloodPressure>[];
  var bppredict = 4; //days that can be predicted into the future accurately -1
  List<charts.Series<BloodPressure, int>> bplist = [];

  Widget bgchart = Text("Loading...");
  Widget bpchart = Text("Loading...");

  dayAssembler(num value) {
    //returns a string according to the day for the day axis labels, assumes 1x daily bg recording
    int val = value.toInt();
    if (val < bgpredict) {
      if (val == bgpredict - 1) {
        return ('1 day ago');
      }
      int day = bgpredict - val;
      return ('$day days ago');
    } else if (val == bgpredict) {
      return ('Today');
    } else {
      if (val == bgpredict + 1) {
        return ('1 day out');
      }
      int day = val - bgpredict;
      return ('$day days out');
    }
  }

  void generateBGList() {
    int day = 0;
    int placemarker;
    int currentmarker = 1;
    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num? value) {
      //give each tick on the x-axis a name from the dayAssembler function
      return dayAssembler(value!);
    });
    patientBGCollection.get().then((docSnapshot) => {
          //if the patient has bg readings, than take the last documents, based off of how many days can be accurrately predicted
          if (docSnapshot.size > 0 && docSnapshot.size >= bgpredict)
            {
              placemarker = docSnapshot.size - bgpredict,
              docSnapshot.docs.forEach((DocumentSnapshot doc) {
                if (currentmarker >= placemarker) {
                  //if this snapshot is in the latest measurements that we want to show
                  num bg = doc.get(
                      "blood glucose (mmol|L)"); //get the persons blood glucose for that day
                  bgdata.add(new BloodGlucose(bg,
                      day)); //create a bloodGlucose object for that day and append it to the bgdata list
                  day++;
                }
                currentmarker++;
              }),
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
              )),
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
                        desiredTickCount: bgpredict * 2 +
                            2), //make x-axis have same amount of ticks for recorded and predicted days
                    tickFormatterSpec: customTickFormatter,
                  ),
                  behaviors: [
                    new charts.ChartTitle('Blood Glucose (mmol/L)',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                  ]),
              setState(() {
                //update bg chart when this function is called
              }),
            }
        });
  }

  void generateBPList() {
    int day = 0;
    int placemarker;
    int currentmarker = 1;
    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num? value) {
      //give each tick on the x-axis a name from the dayAssembler function
      return dayAssembler(value!);
    });
    patientBPCollection.get().then((docSnapshot) => {
          //if the patient has bg readings, than take the last documents, based off of how many days can be accurrately predicted
          if (docSnapshot.size > 0 && docSnapshot.size >= bppredict)
            {
              placemarker = docSnapshot.size - bppredict,
              docSnapshot.docs.forEach((DocumentSnapshot doc) {
                if (currentmarker >= placemarker) {
                  //if this snapshot is in the latest measurements that we want to show
                  num dia = doc.get(
                      "diastolic"); //get the persons blood dia/sys for that day
                  num sys = doc.get("systolic");
                  bpdata.add(new BloodPressure(dia, sys,
                      day)); //create a BloodPressure object for that day and append it to the bpdata list
                  day++;
                }
                currentmarker++;
              }),
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
              )),
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
              )),
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
                        desiredTickCount: bppredict * 2 +
                            2), //make x-axis have same amount of ticks for recorded and predicted days
                    tickFormatterSpec: customTickFormatter,
                  ),
                  behaviors: [
                    new charts.ChartTitle('Systolic/Diastolic (mmHg)',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                  ]),
              setState(() {
                //update bp chart when this function is called
              }),
            }
        });
  }

  @override
  void initState() {
    super.initState();
    generateBGList();
    generateBPList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawers(),
          appBar: AppBar(
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
            title: Text('Future Predictions'),
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

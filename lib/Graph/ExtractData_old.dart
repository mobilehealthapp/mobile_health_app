import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Graph/linetitle.dart';

import '../health_analysis.dart';

final _firestore = FirebaseFirestore.instance;

class ExtractData extends StatefulWidget {
  const ExtractData({Key? key}) : super(key: key);

  @override
  _ExtractDataState createState() => _ExtractDataState();
}

class _ExtractDataState extends State<ExtractData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('patientData')
          .doc(uid)
          .collection('heartRate')
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data1 = [];
        double index = 1.0;

        for (var val in value) {
          int heartrate = val.get('heart rate');
          //[ heartrate.toDouble();
          data1.add(FlSpot(index++, heartrate.toDouble()));
        }
        return Charts(
          list: data1,
        );
      },
    );
  }
}

class ExtractData3 extends StatefulWidget {
  const ExtractData3({Key? key}) : super(key: key);

  @override
  _ExtractData3State createState() => _ExtractData3State();
}

class _ExtractData3State extends State<ExtractData3> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('patientData')
          .doc(uid)
          .collection('bloodGlucose')
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data1 = [];
        double index = 1.0;
        for (var val in value) {
          double glucose = val.get('blood glucose (mmol|L)');
          //[ heartrate.toDouble();
          data1.add(FlSpot(index++, glucose.toDouble()));
          print(glucose);
        }
        return Charts(
          list: data1,
        );
      },
    );
  }
}

class ExtractData2 extends StatefulWidget {
  const ExtractData2({Key? key}) : super(key: key);

  @override
  _ExtractData2State createState() => _ExtractData2State();
}

class _ExtractData2State extends State<ExtractData2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('patientData')
          .doc(uid)
          .collection('bloodPressure')
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data2 = [];
        final List<FlSpot> data3 = [];
        double index = 1;
        double index2 = 1;

        for (var val in value) {
          double dias = val.get('diastolic');
          double sys = val.get('systolic');

          data2.add(FlSpot(index++, dias.toDouble()));
          data3.add(FlSpot(index2++, sys.toDouble()));
        }
        return Charts2(list: data2, list2: data3);
      },
    );
  }
}

class Charts extends StatelessWidget {
  Charts({required this.list});

  List<FlSpot> list = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
      padding: EdgeInsets.fromLTRB(5, 20, 20, 10),
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black),
        color: Colors.blue.shade100,
      ),
      child: LineChart(
        LineChartData(
          titlesData: LineTitles.getTitleData(),
          borderData: FlBorderData(
            show: true,
          ),
          maxX: 10,
          minX: 1,
          maxY: 180,
          minY: 0,

          // backgroundColor: Colors.green,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              colors: [Colors.red],
              spots: list,
            ),
          ],
          axisTitleData: FlAxisTitleData(
            bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'This week',
                textAlign: TextAlign.right
                // textAlign: TextAlign.center,
                ),
          ),
        ),
      ),
    );
  }
}

class Charts2 extends StatelessWidget {
  Charts2({required this.list, required this.list2});

  List<FlSpot> list = [];
  List<FlSpot> list2 = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
      padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
      width: 350,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black),
        color: Colors.blue.shade100,
      ),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(
            show: true,
          ),
          maxX: 30,
          minX: 1,
          maxY: 180,
          minY: 0,

          // backgroundColor: Colors.green,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              colors: [Colors.red],
              spots: list,
            ),
            LineChartBarData(
              isCurved: true,
              colors: [Colors.black],
              spots: list2,
            ),
          ],
        ),
      ),
    );
  }
}

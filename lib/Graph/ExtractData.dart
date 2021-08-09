import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Graph/Charts.dart';
import 'package:mobile_health_app/Graph/datacard.dart';

final _firestore = FirebaseFirestore.instance;

class ExtractDataV2 extends StatefulWidget {
  const ExtractDataV2({Key? key}) : super(key: key);

  @override
  _ExtractDataV2State createState() => _ExtractDataV2State();
}

class _ExtractDataV2State extends State<ExtractDataV2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patientData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('heartRate')
          .orderBy('uploaded')
          .limitToLast(6)
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data1 = [];
        double index = 1.0;
        for (var val in value) {
          int heartrate = val.get('heart rate');
          data1.add(FlSpot(index++, heartrate.toDouble()));
        }
        return Charts(
          yStart: 30,
          bool1: true,
          yLength: 200,
          xLength: 6,
          list: data1,
        );
      },
    );
  }
}

class ExtractData2V2 extends StatefulWidget {
  const ExtractData2V2({Key? key}) : super(key: key);

  @override
  _ExtractData2V2State createState() => _ExtractData2V2State();
}

class _ExtractData2V2State extends State<ExtractData2V2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patientData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('bloodPressure')
          .orderBy('uploaded')
          .limitToLast(6)
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
        return Charts2(
            yStart: 10,
            bool1: true,
            yLength: 180,
            xLength: 6,
            list: data2,
            list2: data3);
      },
    );
  }
}

class ExtractData3V2 extends StatefulWidget {
  const ExtractData3V2({Key? key}) : super(key: key);

  @override
  _ExtractData3V2State createState() => _ExtractData3V2State();
}

class _ExtractData3V2State extends State<ExtractData3V2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patientData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('bloodGlucose')
          .orderBy('uploaded')
          .limitToLast(4)
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data1 = [];
        double index = 1.0;

        for (var val in value) {
          double glucose = val.get('blood glucose (mmol|L)');
          data1.add(FlSpot(index++, glucose.toDouble()));
        }
        return Charts3(
          yStart: 0,
          bool1: true,
          yLength: 10,
          xLength: 6,
          list: data1,
        );
      },
    );
  }
}

class ExtractDataCard extends StatefulWidget {
  const ExtractDataCard({Key? key}) : super(key: key);

  @override
  _ExtractDataCardState createState() => _ExtractDataCardState();
}

class _ExtractDataCardState extends State<ExtractDataCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('patientData').snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        List<DataCard> dataCardList = [];
        for (var val in value) {
          final heartrate = val.get('Average Heart Rate');
          // final bps = val.get('Average Blood Pressure (systolic)');
          // final bpd = val.get('Average Blood Pressure (diastolic)');
          final datacard = DataCard(
            value1: heartrate,
            type1: 'Average heart rate',
            // value2: bps,
            // value3: bpd,
            type2: 'Average Blood Pressure',
          );
          dataCardList.add(datacard);
        }
        return ListView(
          key: UniqueKey(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: dataCardList,
        );
      },
    );
  }
}

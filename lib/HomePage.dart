import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'drawers.dart';
import 'package:mobile_health_app/drawers.dart';
import 'package:fl_chart/fl_chart.dart';

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); //declare reference high up in file
var name; //declare variable high up in file

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var uid; //declare below state

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString(); //convert to string in this method
      }
    } catch (e) {
      print(e);
    }
  }

  getUserData(uid) async {
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
    setState(() {
      name = patientInfo.get('first name');
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getUserData(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      drawer: Drawers(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(
                Icons.logout,
              ),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
          )
        ],
        backgroundColor: kPrimaryColour,
        title: Text(
          'Hello, $name',
          style: kAppBarLabelStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[600],
        onPressed: () {
          Navigator.of(context).pushNamed('/dataInput');
        },
        child: Icon(
          Icons.camera_alt_rounded,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Text(
              ' Recent Analysis',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 15,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Blood pressure for this week',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.black),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                width: 200,
                height: 200,
                // color: Colors.blue,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(
                      show: true,
                    ),
                    maxX: 6,
                    minX: 1,
                    maxY: 180,
                    minY: 50,

                    // backgroundColor: Colors.green,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        colors: [Colors.red],
                        spots: [
                          FlSpot(1, 88),
                          FlSpot(2, 89),
                          FlSpot(3, 78),
                          FlSpot(4, 95),
                          FlSpot(5, 92),
                          FlSpot(6, 92),
                        ],
                      ),
                      LineChartBarData(
                        isCurved: true,
                        colors: [Colors.black],
                        // dotData: FlDotData( // removes dots
                        //   show: false,
                        // ),

                        spots: [
                          FlSpot(1, 148),
                          FlSpot(2, 140),
                          FlSpot(3, 141),
                          FlSpot(4, 142),
                          FlSpot(5, 150),
                          FlSpot(6, 150),
                        ],
                      ),
                    ],
                    axisTitleData: FlAxisTitleData(
                      leftTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Value in mmHg',
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      bottomTitle: AxisTitle(
                          showTitle: true,
                          margin: 0,
                          titleText: 'This week',
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Legend(
                    text: 'Systolic',
                    color: Colors.black,
                  ),
                  Legend(
                    text: 'Diastolic',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Pulse rate for this week',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.black),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                width: 200,
                height: 200,
                // color: Colors.blue,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(
                      show: true,
                    ),
                    maxX: 6,
                    minX: 1,
                    maxY: 150,
                    minY: 50,

                    // backgroundColor: Colors.green,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        colors: [Colors.red],
                        spots: [
                          FlSpot(1, 88),
                          FlSpot(2, 89),
                          FlSpot(3, 78),
                          FlSpot(4, 95),
                          FlSpot(5, 92),
                          FlSpot(6, 92),
                        ],
                      ),
                    ],
                    axisTitleData: FlAxisTitleData(
                      leftTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Value in bpm',
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      bottomTitle: AxisTitle(
                          showTitle: true,
                          margin: 0,
                          titleText: 'This week',
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Blood glucose levels for this week',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.black),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                width: 200,
                height: 200,
                // color: Colors.blue,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(
                      show: true,
                    ),
                    maxX: 6,
                    minX: 1,
                    maxY: 150,
                    minY: 50,

                    // backgroundColor: Colors.green,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        colors: [
                          kPrimaryColour,
                        ],
                        spots: [
                          FlSpot(1, 88),
                          FlSpot(2, 89),
                          FlSpot(3, 78),
                          FlSpot(4, 95),
                          FlSpot(5, 92),
                          FlSpot(6, 92),
                        ],
                      ),
                    ],
                    axisTitleData: FlAxisTitleData(
                      leftTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Value in mmol/L',
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      bottomTitle: AxisTitle(
                          showTitle: true,
                          margin: 0,
                          titleText: 'This week',
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  Legend({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
      style: ElevatedButton.styleFrom(primary: color),
    );
  }
}

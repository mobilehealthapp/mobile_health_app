import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'settings_constants.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColour,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // Container(
          //   padding: EdgeInsets.all(10),
          //   width: 300,
          //   height: 300,
          //   child: LineChart(
          //     LineChartData(
          //       borderData: FlBorderData(show: true),
          //       lineBarsData: [
          //         LineChartBarData(
          //           spots: [
          //             FlSpot(0, 1),
          //             FlSpot(1, 3),
          //             FlSpot(2, 10),
          //             FlSpot(3, 7),
          //             FlSpot(4, 12),
          //             FlSpot(5, 13),
          //             FlSpot(6, 17),
          //             FlSpot(7, 15),
          //             FlSpot(8, 20),
          //           ],
          //           colors: [kPrimaryColour,],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Constants.dart';

class Charts extends StatelessWidget {
  Charts({required this.list, required this.xLength, required this.yLength});

  List<FlSpot> list = [];
  final double? xLength;
  final double? yLength;

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
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: 0,

          // backgroundColor: Colors.green,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              colors: [Colors.red],
              spots: list,
            ),
          ],
        ),
      ),
    );
  }
}

class Charts2 extends StatelessWidget {
  Charts2({required this.list, required this.list2, required this.xLength, required this.yLength});

  List<FlSpot> list = [];
  List<FlSpot> list2 = [];
  final double? xLength;
  final double? yLength;

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
          maxX: xLength,
          minX: 1,
          maxY: yLength,
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
              dotData: FlDotData( // removes dots
                show: false,
              ),
              spots: list2,
            ),
          ],
        ),
      ),
    );
  }
}

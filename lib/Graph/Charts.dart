import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Graph/linetitle.dart';

class Charts extends StatelessWidget {
  Charts(
      {required this.list,
      required this.xLength,
      required this.yLength,
      required this.bool1,
      required this.yStart});

  List<FlSpot> list = [];
  final double? xLength;
  final double? yLength;
  final double? yStart;
  final bool bool1;

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
          titlesData: LineTitles
              .getTitleData(), // the data that will be shown on the y axis.
          borderData: FlBorderData(
            show: true,
          ),
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: yStart,

          // backgroundColor: Colors.green,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              colors: [Colors.red],
              dotData: FlDotData(
                // removes dots
                show: bool1,
              ),
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

class Charts3 extends StatelessWidget {
  Charts3(
      {required this.list,
      required this.xLength,
      required this.yLength,
      required this.bool1,
      required this.yStart});

  List<FlSpot> list = [];
  final double? xLength;
  final double? yLength;
  final double? yStart;
  final bool bool1;

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
          titlesData: LineTitles2.getTitleData(),
          borderData: FlBorderData(
            show: true,
          ),
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: yStart,

          // backgroundColor: Colors.green,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              colors: [Colors.red],
              dotData: FlDotData(
                // removes dots
                show: bool1,
              ),
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
  Charts2(
      {required this.list,
      required this.list2,
      required this.xLength,
      required this.yLength,
      required this.bool1,
      required this.yStart});

  List<FlSpot> list = [];
  List<FlSpot> list2 = [];
  final double? xLength; // maximum X value
  final double? yLength; // maximum y value
  final double? yStart; // minimum y value
  final bool bool1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
      padding: EdgeInsets.fromLTRB(5, 20, 20, 10),
      width: 350,
      height: 350,
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
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: yStart,

          // backgroundColor: Colors.green,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              colors: [Colors.red],
              dotData: FlDotData(
                // removes dots
                show: bool1,
              ),
              spots: list,
            ),
            LineChartBarData(
              isCurved: true,
              colors: [Colors.black],
              dotData: FlDotData(
                // removes dots
                show: bool1,
              ),
              spots: list2,
            ),
          ],
        ),
      ),
    );
  }
}

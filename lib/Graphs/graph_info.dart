import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// TODO: look into creating LineTitles for the x-axis for the health analysis page (make it easier to read)
// TODO: see if it's possible to scroll the graph horizontally (view one week at a time but scroll to see others)

class BPHRLineTitles {
  // used for y-axis line titles on BP and HR graphs
  static getTitleData() {
    return FlTitlesData(
      show: true,
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
          getTitles: (value) {
            int returnValue = value.toInt();
            if (returnValue % 10 == 0 &&
                returnValue <= 220 &&
                returnValue >= 10) {
              return returnValue.toString();
            } else {
              return '';
            }
          },
          reservedSize: 20,
          margin: 10),
    );
  }
}

class BGLineTitles {
  // used for y-axis line titles on BG graphs
  static getTitleData() {
    return FlTitlesData(
      show: true,
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
          getTitles: (value) {
            int returnValue = value.toInt();
            if (returnValue <= 0 &&
                returnValue >= 10) {
              return returnValue.toString();
            } else {
              return '';
            }
          },
          reservedSize: 20,
          margin: 10),
    );
  }
}

class HRCharts extends StatelessWidget {
  // used for HR graph
  HRCharts(
      {required this.dataList,
      required this.xLength,
      required this.yLength,
      required this.showDots,
      required this.yStart,
      required this.unitOfMeasurement});

  List<FlSpot> dataList = []; // list of data to display as fl spots
  final double? xLength; // length of x-axis
  final double? yLength; // length of y-axis
  final double? yStart; // at what value does the y-axis start?
  final bool showDots; // show dots? yes (true) for home page, no (false) for health analysis
  final String unitOfMeasurement; // units of measurement (display along y-axis)

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
          titlesData: BPHRLineTitles.getTitleData(),
          borderData: FlBorderData(
            show: true,
          ),
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: yStart,
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              isCurved: true,
              colors: [Colors.red],
              dotData: FlDotData(
                // removes dots
                show: showDots,
              ),
              spots: dataList,
            ),
          ],
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              titleText: unitOfMeasurement,
              showTitle: true,
            ),
            bottomTitle: AxisTitle(
              titleText: 'Most Recent Uploads',
              showTitle: true,
            ),
          ),
        ),
      ),
    );
  }
}

class BPCharts extends StatelessWidget {
  // used for BP graph
  BPCharts(
      {required this.dataList,
      required this.list2,
      required this.xLength,
      required this.yLength,
      required this.showDots,
      required this.yStart,
      required this.unitOfMeasurement});

  List<FlSpot> dataList = []; // list of data to display as fl spots
  List<FlSpot> list2 =
      []; // another list of data to display as fl spots (need to for BP)
  final double? xLength; // length of x-axis
  final double? yLength; // length of y-axis
  final double? yStart; // at what value does the y-axis start?
  final bool showDots; // show dots? yes (true) for home page, no (false) for health analysis
  final String unitOfMeasurement; // units of measurement (display along y-axis)

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
      padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black),
        color: Colors.blue.shade100,
      ),
      child: LineChart(
        LineChartData(
          titlesData: BPHRLineTitles.getTitleData(),
          borderData: FlBorderData(
            show: true,
          ),
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: yStart,
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              titleText: unitOfMeasurement,
              textStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              showTitle: true,
            ),
            bottomTitle: AxisTitle(
              titleText: 'Most Recent Uploads',
              textStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              showTitle: true,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              isCurved: true,
              colors: [Colors.red],
              dotData: FlDotData(
                // removes dots
                show: showDots,
              ),
              spots: dataList,
            ),
            LineChartBarData(
              preventCurveOverShooting: true,
              isCurved: true,
              colors: [Colors.black],
              dotData: FlDotData(
                // removes dots
                show: showDots,
              ),
              spots: list2,
            ),
          ],
        ),
      ),
    );
  }
}

class BGCharts extends StatelessWidget {
  // used for BG graph
  BGCharts({
    required this.dataList,
    required this.xLength,
    required this.yLength,
    required this.showDots,
    required this.yStart,
    required this.unitOfMeasurement,
  });

  List<FlSpot> dataList = [];
  final double? xLength; // length of x-axis
  final double? yLength; // length of y-axis
  final double? yStart; // at what value does the y-axis start?
  final bool showDots; // show dots? yes (true) for home page, no (false) for health analysis
  final String unitOfMeasurement; // units of measurement (display along y-axis)

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
          titlesData: BGLineTitles.getTitleData(),
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
              preventCurveOverShooting: true,
              isCurved: true,
              colors: [Colors.red],
              dotData: FlDotData(
                // removes dots
                show: showDots,
              ),
              spots: dataList,
            ),
          ],
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              titleText: unitOfMeasurement,
              showTitle: true,
            ),
            bottomTitle: AxisTitle(
              titleText: 'Most Recent Uploads',
              showTitle: true,
            ),
          ),
        ),
      ),
    );
  }
}

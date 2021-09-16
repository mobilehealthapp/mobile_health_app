import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

//The original graph_info.dart had a lot of poorly named variables
//And some essentially copy and pasted classes.
//This file SHOULD*** replace it's functionality in an easier to read/maintain way
//It's separate so it's easier to test for compatibility

//BPHR returned 10 <= value <= 220 in increments of 10,
//whereas BG returned 0 <= value <= 10, in increments of 1.

class GraphType{
  const GraphType(this.start, this.stop, this.step);
  final int start;
  final int stop;
  final int step;
}
const GraphType HR = GraphType(0, 10, 1);
const GraphType BP = GraphType(10, 220, 10);
const GraphType BG = GraphType(0, 10, 1);

class YAxisLineTitles {
  static getTitleData(GraphType graphType) {
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
            if (returnValue >= graphType.start &&
                returnValue <= graphType.stop &&
                returnValue % graphType.step == 0) {
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

class HealthCharts extends StatelessWidget {
  List<FlSpot> primaryData = []; // list of data to display as fl spots
  List<FlSpot> secondaryData = []; // another list of data to display as fl spots (need to for BP)
  final double? xLength; // length of x-axis
  final double? yLength; // length of y-axis
  final double? yStart; // at what value does the y-axis start
  final bool showDots; // show dots? yes (true) for home page, no (false) for health analysis
  final String unitOfMeasurement; // units of measurement (display along y-axis)
  final GraphType graphType;

  HealthCharts(
    {required this.primaryData,
    required this.xLength,
    required this.yLength,
    required this.showDots,
    required this.yStart,
    required this.unitOfMeasurement,
    required this.graphType,
    this.secondaryData = const []});

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> barData = [
      LineChartBarData(
        preventCurveOverShooting: true,
        isCurved: true,
        colors: [Colors.red],
        dotData: FlDotData(
          // removes dots
          show: showDots,
        ),
        spots: primaryData,
      )];
      if (secondaryData != []) {
        barData.add(
            LineChartBarData(
              preventCurveOverShooting: true,
              isCurved: true,
              colors: [Colors.black],
              dotData: FlDotData(
                // removes dots
                show: showDots,
              ),
              spots: secondaryData,
            )
        );
      }

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
          titlesData: YAxisLineTitles.getTitleData(this.graphType),
          borderData: FlBorderData(show: true),
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
          lineBarsData: barData,
        ),
      ),
    );
  }
}
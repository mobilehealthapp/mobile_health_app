import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/* <ramble>
 This is the updated/simplified version of this file.
 it's been tested and seems to be working the same.
 The original graph_info.dart had a lot of vaguely named variables
 And some essentially copy and pasted classes.
 This file SHOULD*** replace it's functionality in an easier to read/maintain way.
 with some slight optimizations.

 Other than that documentation and commenting was added.

 The original is saved under <root>/legacy/old_graph_info.txt
 </ramble>
*/

class GraphType {
  const GraphType(this.start, this.stop, this.step);
  final int start;
  final int stop;
  final int step;
}

class HealthCharts extends StatelessWidget {
  /// HealthCharts is a general chart widget for graphing health care parameters.
  ///
  /// [primaryDataList] Acts as the main data source being graphed, and
  /// [secondaryDataList] is another list of data (need to for diastolic BP.)
  /// [maxX], [maxY] and [minY] are used to specify graph axis parameters.
  /// [showDots] True if dots should be drawn on the graph.
  /// [unitOfMeasurement] The unit of measurement to display along y-axis.
  /// [graphType] essentially acts as a way to specify scale of y-axis using start,stop(both inclusive),step
  /// within HealthCharts there are three predefined GraphType objects, HR, BP and BG.
  final List<FlSpot> primaryDataList;
  final List<FlSpot>?
      secondaryDataList; // another list of data to display as fl spots (need to for BP)
  final double? maxX; // length of x-axis
  final double? maxY; // length of y-axis
  final double? minY; // at what value does the y-axis start
  final bool
      showDots; // show dots? yes (true) for home page, no (false) for health analysis
  final String unitOfMeasurement; // units of measurement (display along y-axis)
  final GraphType graphType;

  static GraphType HR = GraphType(0, 10, 1);
  static GraphType BP = GraphType(10, 220, 10);
  static GraphType BG = GraphType(0, 10, 1);

  HealthCharts(
      {required this.primaryDataList,
      required this.maxX,
      required this.maxY,
      required this.showDots,
      required this.minY,
      required this.unitOfMeasurement,
      required this.graphType,
      this.secondaryDataList});

  static _generateTitleData(GraphType graphType) {
    ///Given a GraphType(a glorified tuple consisting of start, stop(both inclusive), step) yaxis range can be created.
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

  List<LineChartBarData> _generateBarDataList() {
    ///Creates List<LineChartBarData> outside of build for neatness.

    //Create a LineChartBarData for the primaryDataList
    List<LineChartBarData> barData = [
      LineChartBarData(
        preventCurveOverShooting: true,
        isCurved: true,
        colors: [Colors.red],
        dotData: FlDotData(
          // removes dots
          show: showDots,
        ),
        spots: primaryDataList,
      )
    ];

    //and if secondaryDataList was instantiated, add it to the list.
    if (secondaryDataList != null) {
      barData.add(LineChartBarData(
        preventCurveOverShooting: true,
        isCurved: true,
        colors: [Colors.black],
        dotData: FlDotData(
          // removes dots
          show: showDots,
        ),
        spots: secondaryDataList,
      ));
    }
    return barData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
      padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
      width: 350,
      height: 415,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black),
        color: Colors.blue.shade100,
      ),
      child: LineChart(
        LineChartData(
          titlesData: _generateTitleData(graphType),
          borderData: FlBorderData(show: true),
          maxX: maxX,
          minX: 1,
          maxY: maxY,
          minY: minY,
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
                height: 1.5,
                fontSize: 15.0,
                color: Colors.black,
              ),
              showTitle: true,
            ),
          ),
          lineBarsData: _generateBarDataList(),
        ),
      ),
    );
  }
}

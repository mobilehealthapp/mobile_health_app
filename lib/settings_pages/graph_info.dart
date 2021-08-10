import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineTitles {
  static getTitleData() {
    return FlTitlesData(
      show: true,
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
              case 60:
                return '60';
              case 70:
                return '70';
              case 80:
                return '80';
              case 90:
                return '90';
              case 100:
                return '100';
              case 110:
                return '110';
              case 120:
                return '120';
              case 130:
                return '130';
              case 140:
                return '140';
              case 150:
                return '150';
              case 160:
                return '160';
              case 170:
                return '170';
              case 180:
                return '180';
              case 190:
                return '190';
              case 200:
                return '200';
            }
            return '';
          },
          reservedSize: 20,
          margin: 10),
    );
  }
}

class LineTitles2 {
  static getTitleData() {
    return FlTitlesData(
      show: true,
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
            }
            return '';
          },
          reservedSize: 20,
          margin: 10),
    );
  }
}

class Charts extends StatelessWidget {
  Charts(
      {required this.list,
      required this.xLength,
      required this.yLength,
      required this.bool1,
      required this.yStart,
      required this.units});

  List<FlSpot> list = [];
  final double? xLength;
  final double? yLength;
  final double? yStart;
  final bool bool1;
  final String units;

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
                show: bool1,
              ),
              spots: list,
            ),
          ],
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              titleText: units,
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

class Charts2 extends StatelessWidget {
  Charts2(
      {required this.list,
      required this.list2,
      required this.xLength,
      required this.yLength,
      required this.bool1,
      required this.yStart,
      required this.units});

  List<FlSpot> list = [];
  List<FlSpot> list2 = [];
  final double? xLength;
  final double? yLength;
  final double? yStart;
  final bool bool1;
  final String units;

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
          titlesData: LineTitles.getTitleData(),
          borderData: FlBorderData(
            show: true,
          ),
          maxX: xLength,
          minX: 1,
          maxY: yLength,
          minY: yStart,
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              titleText: units,
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
                show: bool1,
              ),
              spots: list,
            ),
            LineChartBarData(
              preventCurveOverShooting: true,
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

class Charts3 extends StatelessWidget {
  Charts3({
    required this.list,
    required this.xLength,
    required this.yLength,
    required this.bool1,
    required this.yStart,
    required this.units,
  });

  List<FlSpot> list = [];
  final double? xLength;
  final double? yLength;
  final double? yStart;
  final bool bool1;
  final String units;

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
              preventCurveOverShooting: true,
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
            leftTitle: AxisTitle(
              titleText: units,
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
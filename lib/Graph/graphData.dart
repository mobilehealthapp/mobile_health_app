// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:mobile_health_app/Constants.dart';
// import 'package:mobile_health_app/data1.dart';
//
// class Chart1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
//       padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
//       width: 350,
//       height: 350,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(color: Colors.black),
//         color: Colors.blue.shade100,
//       ),
//       child: LineChart(
//         LineChartData(
//           borderData: FlBorderData(
//             show: true,
//           ),
//           maxX: 6,
//           minX: 1,
//           maxY: 180,
//           minY: 50,
//
//           // backgroundColor: Colors.green,
//           lineBarsData: [
//             LineChartBarData(isCurved: true, colors: [
//               Colors.red
//             ], spots: [
//               FlSpot(1, 88),
//               FlSpot(2, 89),
//               FlSpot(3, 78),
//               FlSpot(4, 95),
//               FlSpot(5, 92),
//               FlSpot(6, 100),
//             ]),
//             LineChartBarData(
//               isCurved: true,
//               colors: [Colors.black],
//               // dotData: FlDotData( // removes dots
//               //   show: false,
//               // ),
//               spots: [
//                 FlSpot(1, 148),
//                 FlSpot(2, 140),
//                 FlSpot(3, 141),
//                 FlSpot(4, 142),
//                 FlSpot(5, 150),
//                 FlSpot(6, 150),
//               ],
//             )
//           ],
//           // gridData: FlGridData(
//           //   // removes grid
//           //   show: false,
//           // ),
//
//           axisTitleData: FlAxisTitleData(
//             leftTitle: AxisTitle(
//               showTitle: true,
//               titleText: 'mm Hg ',
//             ),
//             bottomTitle: AxisTitle(
//                 showTitle: true,
//                 margin: 0,
//                 titleText: 'This week',
//                 textAlign: TextAlign.right
//                 // textAlign: TextAlign.center,
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Chart2 extends StatelessWidget {
//   const Chart2({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
//       padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
//       width: 350,
//       height: 350,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(color: Colors.black),
//       ),
//       child: LineChart(
//         LineChartData(
//           borderData: FlBorderData(
//             show: true,
//           ),
//           minX: 1,
//           maxX: 6,
//           minY: 0,
//           maxY: 20,
//           // backgroundColor: Colors.green,
//           lineBarsData: [
//             LineChartBarData(
//               isCurved: true,
//               colors: [Colors.black],
//               // dotData: FlDotData( // removes dots
//               //   show: false,
//               // ),
//               spots: [
//                 FlSpot(1, 2.4),
//                 FlSpot(2, 2.5),
//                 FlSpot(3, 4),
//                 FlSpot(4, 2),
//                 FlSpot(5, 4.5),
//                 FlSpot(6, 5),
//               ],
//             )
//           ],
//           // gridData: FlGridData(
//           //   // removes grid
//           //   show: false,
//           // ),
//
//           axisTitleData: FlAxisTitleData(
//             leftTitle: AxisTitle(
//               showTitle: true,
//               titleText: 'mmol/L ',
//             ),
//             bottomTitle: AxisTitle(
//                 showTitle: true,
//                 margin: 0,
//                 titleText: 'This week',
//                 textAlign: TextAlign.right
//                 // textAlign: TextAlign.center,
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Chart3 extends StatelessWidget {
//   const Chart3({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
//       padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
//       width: 350,
//       height: 500,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(color: Colors.black),
//       ),
//       child: LineChart(
//         LineChartData(
//           borderData: FlBorderData(
//             show: true,
//           ),
//           minX: 1,
//           maxX: 6,
//           minY: 30,
//           maxY: 200,
//           // backgroundColor: Colors.green,
//           lineBarsData: [
//             LineChartBarData(
//               isCurved: true,
//               colors: [Colors.black],
//               // dotData: FlDotData( // removes dots
//               //   show: false,
//               // ),
//               spots: [
//                 FlSpot(1, 80),
//                 FlSpot(2, 40),
//                 FlSpot(3, 45),
//                 FlSpot(4, 50),
//                 FlSpot(5, 60),
//                 FlSpot(6, 34),
//               ],
//             )
//           ],
//           // gridData: FlGridData(
//           //   // removes grid
//           //   show: false,
//           // ),
//
//           axisTitleData: FlAxisTitleData(
//             leftTitle: AxisTitle(
//               showTitle: true,
//               titleText: 'bbm ',
//             ),
//             bottomTitle: AxisTitle(
//                 showTitle: true,
//                 margin: 0,
//                 titleText: 'This week',
//                 textAlign: TextAlign.right
//                 // textAlign: TextAlign.center,
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// import 'package:flutter/material.dart';
// import 'package:mobile_health_app/Constants.dart';
//
// class SummaryCard extends StatelessWidget {
//   SummaryCard({
//     required this.value,
//     required this.type,
//   });
//
//   final String type;
//   final String value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     type,
//                     style: kTextLabel2,
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Text(
//                     value,
//                     style: kTextLabel2,
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Legend extends StatelessWidget {
//   Legend({required this.text, required this.color});
//
//   final String text;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {},
//       child: Text(text),
//       style: ElevatedButton.styleFrom(
//         primary: color,
//       ),
//     );
//   }
// }

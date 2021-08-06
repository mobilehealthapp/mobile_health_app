// import 'package:flutter/material.dart';
// import 'package:mobile_health_app/Constants.dart';
// import 'package:mobile_health_app/Drawers/drawers.dart';
//
// class HealthAnalysis extends StatelessWidget {
//   const HealthAnalysis({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawers(),
//       appBar: AppBar(
//         backgroundColor: kPrimaryColour,
//         title: Text('Health Analysis'),
//       ),
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 child: Card(math: 'Median'),
//                 padding: EdgeInsets.only(bottom: 20.0),
//               ),
//             ),
//             Expanded(
//               child: Card(math: 'Variance'),
//             ),
//             Expanded(
//               child: Card(math: 'Standard Deviation'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Card extends StatelessWidget {
//   Card({required this.math});
//
//   final String math;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(9.0),
//         child: Text(
//           math,
//           style: kTextLabel1,
//         ),
//       ),
//       margin: EdgeInsets.all(25.0),
//       decoration: BoxDecoration(
//         color: Colors.lightBlue,
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//     );
//   }
// }
